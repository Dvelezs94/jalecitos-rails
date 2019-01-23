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
    when object.class == ( Package || Offer )
      if notification.action == "ha finalizado"
       finance_path(:table => notification.query_url, :review => true, :notification => notification.id)
      else
       finance_path(:table => notification.query_url)
     end
    when object.class == Dispute
       order_dispute_path(object.order.uuid, object)

    when object.class == Order
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
      when object.class == Order
         "la orden #{object.uuid} por la cantidad de $#{object.total} MXN"
    end
  end

  def cons_mult_helper number
    number = number * 1
    number
  end

  # Earning for the worker
  def get_order_earning price
    (price * 0.90).round(2)
  end

  def get_order_fee price
    (price * 0.10).round(2)
  end

  def order_tax price
    (price * 0.16).round(2)
  end

  # Get toal price of order, with taxes included
  def purchase_order_total price
    iva = order_tax(price)
    (price + iva).round(2)
  end

  def cons_mult_helper_times (credits_list, percent)
    # p "x" * 600
    # p numbers
    calculated = []
    credits_list.each do |l|
      res = l["total"] / 11 * percent
      calculated << {"id"=>l["id"], "total"=>res}
    end
    calculated
  end

  def form_method_helper
    actions = ["edit", "update", "edit_packages", "update_packages"]
    if actions.include?(params[:action])
      :patch
    else
      :post
    end
  end

  def meta_tags
    if @gig.present? && current_page?( user_gig_path(@gig.user, @gig) )
        "<title>#{@gig.profession} en #{@gig.location} para #{@gig.name}</title>
        <meta name='description' content='#{@gig.profession} en #{@gig.location} para #{@gig.name}. Contrata hoy expertos en #{@gig.category.name} en Jalecitos.'>
        <meta name='keywords' content='#{@gig.location},#{@gig.profession},#{@gig.tag_list.join(',')}'>
        <meta name='category' content='#{@gig.category.name}'>".html_safe
    elsif @request.present? && current_page?( request_path(@request) )
        "<title>Trabajo de #{@request.profession} en #{@request.location} | Encontrar trabajo de #{@request.profession} por internet.</title>
        <meta name='description' content='Se solicita #{@request.profession} en #{@request.location} para #{@request.name}. Registrate hoy en Jalecitos para encontrar trabajo.'>
        <meta name='keywords' content='#{@request.location},#{@request.profession},#{@request.tag_list.join(',')}'>
        <meta name='category' content='#{@request.category.name}'>".html_safe
    elsif current_page?( root_path ) && params[:query]
        "<title>Encuentra las mejores oportunidades de trabajo o Expertos para contratar  en línea utilizando Jalecitos</title>
        <meta name='description' content='Necesitas trabajo o encontrar a un experto para alguna necesidad? Utiliza Jalecitos para encontrar empleo o expertos.'>
        <meta name='keywords' content='encontrar, trabajo, empleos, expertos, internet'>
        <meta name='category' content='Trabajo, Empleo'>".html_safe
    else
        "<title>Jalecitos</title>".html_safe
    end
  end

  def star_display_helper number
    decimal = number % 1
    if number == 0
      "Sin calificaciones"
    else
      html = ""
      #number of complete stars
      number.to_i.times do
        html << image_tag("star-on", title: number)
      end
      #if has decimal...
      if decimal > 0
        ( decimal < 0.25 ) ? html << image_tag("star-off", title: number) : nil

        ( decimal.between?( 0.25, 0.75 ) )? html << image_tag("star-half", title: number) : nil

        ( decimal > 0.75 )? html << image_tag("star-on", title: number) : nil
      end
      #stars that doesnt have
      ( (5-number).to_i ).times do
        html << image_tag("star-off", title: number)
      end
      #return it
      html.html_safe
    end
  end

end
