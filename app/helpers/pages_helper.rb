module PagesHelper
  #devise
  def resource_name
    :user
  end

  def resource_class
     User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def homepage_content_helper
    if  has_role?(:user) && params[:query]
      render 'shared_user/root/homepage_query'
    elsif has_role?(:user)
       render 'shared_user/root/homepage'
    else
       render 'shared_guest/guest_page'
    end
  end

  def sign_script_helper
    if current_user.nil?
      javascript_include_tag 'sign', 'data-turbolinks-track': 'reload'
    end
  end
end
