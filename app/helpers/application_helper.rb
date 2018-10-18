module ApplicationHelper

  def nav_links_helper
    if has_role?(:admin)
      render 'shared_admin/nav_links_admin'
    elsif  has_role?(:user)
      render 'shared_user/nav_links_user'
    else
      render 'shared_guest/nav_links_guest'
    end
  end

  def homepage_content_helper
     if  has_role?(:user)
       render 'shared_user/interesting_gigs'
     else
       render 'shared_guest/guest_page'
     end
  end

  def notification_helper
    alert = (flash[:alert] || flash[:error] || flash[:notice])
    if alert
        notification_generator_helper alert
    end
  end

  def notification_generator_helper msg
     js add_gritter(msg, :title=>"Jalecitos", :sticky => false, :time => 2000 )
  end

  def google_scripts_helper
    if params[:action] == 'new' || params[:action] == 'edit' 
      (javascript_include_tag 'google_functions', 'data-turbolinks-track': 'reload')+
      (javascript_include_tag "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAP_API']}&libraries=places&callback=activatePlacesSearch", 'data-turbolinks-track': 'reload')
     end
  end

  def back_no_cache_helper
    if params[:action] == 'new' || params[:action] == 'edit'
      javascript_include_tag 'back-no-cache', 'data-turbolinks-track': 'reload'
     end
  end

  def image_display_helper image
    if image.nil?
      "https://picsum.photos/600/400?image=#{Faker::Number.between(1, 500)}"
    else
      image
    end
  end


  def tag_variable_helper
     (params[:controller] == 'gigs')? 'gig[tag_list]' : 'request[tag_list]'
  end


  def avatar_display_helper image
    if image.nil?
      "https://picsum.photos/100/100?image=#{Faker::Number.between(1, 500)}"
    else
      image
    end
  end

end
