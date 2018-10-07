module ApplicationHelper

  def nav_links_helper
    if logged_in?(:user)
      render 'shared/nav_links_user'
    else
      render 'shared/nav_links_guest'
    end
  end

  def hompepage_content_helper
     if  has_role?(:admin)
       render 'shared_admin/admin_dashboard'
     elsif  has_role?(:user)
       render 'shared/interesting_gigs'
     else
       (render 'shared/masthead_image')+
       (render 'shared/icons_home')+
       (render 'shared/images_home')+
       (render 'shared/mastbottom')
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
    if params[:controller] == 'gigs' && ( params[:action] == 'new' || params[:action] == 'edit' )
      (javascript_include_tag 'google_functions', 'data-turbolinks-track': 'reload')+
      (javascript_include_tag "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAP_API']}&libraries=places&callback=activatePlacesSearch", 'data-turbolinks-track': 'reload')
     end
  end
end
