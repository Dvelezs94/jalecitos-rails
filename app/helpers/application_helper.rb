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

  def active? path
    "active" if current_page? path
  end

  def notification_helper
    msg = (flash[:alert] || flash[:error] || flash[:notice] || flash[:warning] || flash[:success] || flash[:progress])
    if msg
      case
      when flash[:error] || flash[:alert]
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
      image.url
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

  def opposite_conversation_user(conversation, current_user)
    @opposite_user = conversation.sender == current_user ? conversation.recipient : conversation.sender
  end

  def url_generator_helper (notification, object)
    case
    when object.class == Request
       request_path(object.slug)
    when object.class == Package
      if notification.action == "ha finalizado"
       finance_path(:table => notification.query_url, :review => true, :notification => notification.id)
      else
       finance_path(:table => notification.query_url)
     end
    when object.class == Dispute
       order_dispute_path(object.order.uuid, object)
    when object.class == Offer
       finance_path(:table => notification.query_url)
    end
  end

  def build_notifiable_type (object)
    case
    when object.class == Request
       "en el pedido #{object.name}"
    when object.class == Package
       "en el jale Voy a #{object.gig.name} por el paquete #{object.pack_type}"
     when object.class == Dispute
        "en la orden #{object.order.uuid}"
     when object.class == Offer
        "en el pedido #{object.request.name}"
    end
  end

  def cons_mult_helper number
    number = number * 1.1
    number
  end

  def cons_mult_helper_times (credits_list, percent)
    # p "x" * 600
    # p numbers
    calculated = []
    credits_list.each do |l|
      res = l["total"] / 11 * percent
      calculated << {"id"=>l["id"], "total"=>res}
    end
    p "x" *500
    p calculated
    calculated
  end

  def form_method_helper
    if params[:action] == "edit" || params[:action] == "update" || params[:action] == "edit_packages" ||params[:action] == "update_packages"
      :patch
    else
      :post
    end
  end
end
