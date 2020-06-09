class ApplicationController < ActionController::Base
  # before_action :check_if_user_banned, if: :important_route?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_sign_in_at_periodically
  before_action :set_location
  UPDATE_LOGIN_PERIOD = 1.hours
  include ApplicationHelper

  protected
 def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :password_confirmation])
   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :country])
 end

 #old log out of user when banned
 # def check_if_user_banned
 #   if current_user && current_user.banned?
 #     sign_out(current_user)
 #   end
 # end

def important_route? #just log out the banned user if the request is html and specified routes
  #cant logout on home or gig because if i log out it doesnt redirect because i can go home or gig without an user, so mobile users goes to desktop user home at logout, and its wrong
  if (params[:action] == "hire" || params[:action] == "finance" ||  params[:action] == "configuration" || params[:controller] == "conversations") && request.format.html?
    return true
  else
    return false
  end
end

 def update_sign_in_at_periodically
    # use session cookie to avoid hammering the database
    if !session[:last_login_update_at] or session[:last_login_update_at] < UPDATE_LOGIN_PERIOD.ago
      session[:last_login_update_at] = Time.now
      if user_signed_in? and current_user.current_sign_in_at < 1.minute.ago # prevents double logins
        sign_in(current_user, :force => true)
      end
    end
  end

  def current_user #eager load of user
      @current_user ||= super.tap do |user|
        if params[:controller] == "gigs" &&  params[:action] == "show"
        ::ActiveRecord::Associations::Preloader.new.preload(user, [:score])
        else
        # ::ActiveRecord::Associations::Preloader.new.preload(user)
        end
      end
  end



  #behave as request of "user"
  def self.renderer_with_signed_in_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    }
    renderer.new('warden' => proxy)
  end

  def is_number? string
    true if Float(string) rescue false
  end

  def set_location
    if current_user && current_user.lat.present? && current_user.lng.present?
      @mylat = current_user.lat
      @mylng = current_user.lng
      @myaddress = current_user.address_name
    elsif cookies[:mylat] && cookies[:mylng] &&  cookies[:myaddress]# if cookie, grab from there
      @mylat = cookies[:mylat]
      @mylng = cookies[:mylng]
      @myaddress = cookies[:myaddress]
    else #try to get lat and lng from google
      begin
        @userinfo = Geokit::Geocoders::MultiGeocoder.geocode(request.ip)
        raise "error geocoding" if @userinfo.success == false
        @mylat = @userinfo.lat
        @mylng = @userinfo.lng
        @myaddress = @userinfo.full_address
      rescue #put mexico city lat and lng as default if google fails
        @mylat = 19.432608
        @mylng = -99.133209
        @myaddress = "Mexico City, Mexico"
      end
      #save cookies so server doesnt make a lot of requests to google
        cookies[:mylat] = {
          value: @mylat,
          expires: (ENV.fetch("RAILS_ENV") == "production")? 1.day: 10.minutes
        }
        cookies[:mylng] = {
          value: @mylng,
          expires: (ENV.fetch("RAILS_ENV") == "production")? 1.day: 10.minutes
        }
        cookies[:myaddress] = {
          value: @myaddress,
          expires: (ENV.fetch("RAILS_ENV") == "production")? 1.day: 10.minutes
        }
    end
  end

end
