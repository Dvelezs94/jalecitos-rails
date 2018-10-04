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
       render 'shared/gig_links'
     else
       (render 'shared/masthead_image')+
       (render 'shared/icons_home')+
       (render 'shared/images_home')+
       (render 'shared/mastbottom')
     end
  end

end
