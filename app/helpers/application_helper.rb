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
    msg = (flash[:alert] || flash[:error] || flash[:notice] || flash[:warning] || flash[:success] || flash[:progress])

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
        when flash[:progress]
          flash_type = :progress
      end
      notification_generator_helper msg, flash_type
    end
  end

  def notification_generator_helper msg, flash_type
     js add_gritter(msg, :image => flash_type, :title=>"Jalecitos", :sticky => false, :time => 2000 )
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
    @opposite_user = conversation.sender == current_user ? conversation.recipient : current_user
  end

  def url_generator_helper (model)
    case
    when model.class == Request
       request_path(model)
    when model.class == Gig
       user_gig_path(model.user, model.slug)
    end
  end

  def build_notifiable_type (model)
    case
    when model.class == Request
       "en tu pedido #{model.name}"
    when model.class == Gig
       "en tu jale #{model.name}"
    end
  end
end
