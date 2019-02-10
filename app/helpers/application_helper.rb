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

  def create_notification(user, recipient, message, model, query_url=nil, review_id=nil)
    Notification.create!(recipient: recipient, user: user, action: message, notifiable: model, query_url: query_url, review_id: review_id)
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
      "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/app_images/gig-no-image-2.png"
    else
      image.url
    end
  end


  def tag_variable_helper
     (params[:controller] == 'gigs')? 'gig[tag_list]' : 'request[tag_list]'
  end


  def avatar_display_helper image
    if image.nil?
      "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/app_images/gig-no-image-2.png"
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
    when object.class ==  Offer || object.class ==  Package
      if notification.action == "ha finalizado"
       finance_path(:table => notification.query_url, :review => true, :notification => notification.id)
      else
       finance_path(:table => notification.query_url)
     end
    when object.class == Dispute
       order_dispute_path(object.order.uuid, object)
    when object.class == Order
       finance_path(:table => notification.query_url)
    when object.class == Reply
       order_dispute_path(object.dispute.order.uuid, object.dispute)
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
        "la orden #{object.uuid} por la cantidad de $#{object.total} MXN. Ten en cuenta que puede tardar hasta 72 hrs para aparecer en tu cuenta bancaria."
    when object.class == Reply
        "en la disputa de la orden #{object.dispute.order.uuid}"
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
        "<meta name='description' content='Expertos en oficios | Hogar y Oficina'>".html_safe
    end
  end

  def star_display_helper number
    decimal = number % 1
    if number == 0
      "Sin reseñas"
    else
      html = ""
      #number of complete stars
      number.to_i.times do
        html << image_tag("star-on", title: number)
      end
      #if has decimal...
      if decimal > 0
        html << image_tag("star-off", title: number.round(1)) if decimal < 0.25

        html << image_tag("star-half", title: number.round(1)) if decimal.between?( 0.25, 0.75 )

        html << image_tag("star-on", title: number.round(1)) if decimal > 0.75
      end
      #stars that doesnt have
      ( (5-number).to_i ).times do
        html << image_tag("star-off", title: number)
      end
      #return it
      html.html_safe
    end
  end

  def score_average us
    if us.employee_score_times == 0.0 && us.employer_score_times == 0.0
      0.0
    elsif us.employer_score_times == 0.0
      us.employee_score_average
    elsif us.employee_score_times == 0.0
      us.employer_score_average
    else
      score_average = ( ( us.employee_score_average* us.employee_score_times)+( us.employer_score_average* us.employer_score_times) ) / (us.employer_score_times + us.employee_score_times )
    end
  end

  def ios_pwa_tags
    "<meta name='apple-mobile-web-app-capable' content='yes'>
    <meta name='apple-mobile-web-app-status-bar-style' content='default'>
    <link rel='apple-touch-icon' href='touch-icon-iphone.png'>
    <link rel='apple-touch-icon' sizes='152x152' href='touch-icon-ipad.png'>
    <link rel='apple-touch-icon' sizes='180x180' href='touch-icon-iphone-retina.png'>
    <link rel='apple-touch-icon' sizes='167x167' href='touch-icon-ipad-retina.png'>
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphone5_splash.png' media='(device-width: 320px) and (device-height: 568px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphone6_splash.png' media='(device-width: 375px) and (device-height: 667px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphoneplus_splash.png' media='(device-width: 621px) and (device-height: 1104px) and (-webkit-device-pixel-ratio: 3)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphonex_splash.png' media='(device-width: 375px) and (device-height: 812px) and (-webkit-device-pixel-ratio: 3)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphonexr_splash.png' media='(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/iphonexsmax_splash.png' media='(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 3)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/ipad_splash.png' media='(device-width: 768px) and (device-height: 1024px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/ipadpro1_splash.png' media='(device-width: 834px) and (device-height: 1112px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/ipadpro3_splash.png' media='(device-width: 834px) and (device-height: 1194px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />
    <link href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/splashscreens/ipadpro2_splash.png' media='(device-width: 1024px) and (device-height: 1366px) and (-webkit-device-pixel-ratio: 2)' rel='apple-touch-startup-image' />".html_safe
  end

  def platform_redirect_root_path
    cookies.signed[:mb] ? mobile_sign_in_path : root_path
  end

end
