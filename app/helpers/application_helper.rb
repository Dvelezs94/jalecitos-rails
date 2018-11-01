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

  def notification_helper
    msg = (flash[:alert] || flash[:error] || flash[:notice] || flash[:warning] || flash[:success])

    if msg
      case
        when flash[:alert]
          flash_type = :alert
        when flash[:error]
          flash_type = :error
        when flash[:notice]
          flash_type = :notice
        when flash[:warning]
          flash_type = :warning
        when flash[:success]
          flash_type = :success
      end

      notification_generator_helper msg, flash_type
    end
  end

  def notification_generator_helper msg, flash_type
     js add_gritter(msg, :image => flash_type, :title=>"Jalecitos", :sticky => false, :time => 2000 )
  end

  def google_scripts_helper
    if params[:action] == 'new' || params[:action] == 'edit' || (params[:controller] == 'pages' &&  current_user )
      (javascript_include_tag 'google_functions', 'data-turbolinks-track': 'reload')+
      (javascript_include_tag "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAP_API']}&libraries=places&callback=activatePlacesSearch", 'data-turbolinks-track': 'reload')
     end
  end

  def back_no_cache_helper
    if params[:action] == 'new' || params[:action] == 'edit'
      javascript_include_tag 'back-no-cache'
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

  def gig_class_helper
    (params[:controller] == 'users')? 'col-lg-3 col-md-4 col-sm-6 col-12 single_gig' : 'col-lg-2 col-md-4 col-sm-6 col-12 single_gig'
  end

  def opposite_conversation_user(conversation, current_user)
    @opposite_user = conversation.sender.slug == current_user.slug ? conversation.recipient.slug : current_user.slug
  end

end
