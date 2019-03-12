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
    Notification.create(user: user, recipient: recipient, action: message, notifiable: model, query_url: query_url, review_id: review_id)
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
      if notification.action == "ha finalizado" || notification.action == "Se ha finalizado"
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

  def build_notification_text (notification, object, html=true)
    text = ""
    if notification.action != "Se ha finalizado" #need to have user
      text = "<strong>#{notification.user.slug}</strong> #{notification.action} "
      case
      when object == nil #deleted gig (package also)
        text += "un <strong>Jale eliminado</strong>"
      when object.class == Request
        text += "en el pedido #{object.title}"
      when object.class == Package
        text += "el jale #{object.gig.title} por el paquete "+ I18n.t("gigs.packages.#{object.pack_type}")
      when object.class == Dispute
        text += "en la orden #{object.order.uuid}"
      when object.class == Offer
        text += "el pedido #{object.request.title}"
      when object.class == Order
        text += "la orden #{object.uuid} por la cantidad de $#{object.total} MXN. Ten en cuenta que puede tardar hasta 72 hrs para aparecer en tu cuenta bancaria."
      when object.class == Reply
        text += "en la disputa de la orden #{object.dispute.order.uuid}"
      end
    else
      text = "#{notification.action} "
      case
      when object == nil #deleted gig (package also)
        text += "un <strong>Jale eliminado</strong>"
      when object.class == Package
        text = "el jale #{object.gig.title} por el paquete "+ I18n.t("gigs.packages.#{object.pack_type}")
      when object.class == Offer
        text = "el pedido #{object.request.title}"
      end
    end
    if html == true
      text.html_safe
    else
      ActionView::Base.full_sanitizer.sanitize(text)
    end
  end

  def cons_mult_helper number
    number = number * 1
    number
  end

  # Earning for the worker
  def get_order_earning base
    # Constant Increment to keep our loss at minimum
    ci = 10
    # Formula to get earnings based on the base  price (package or offer number)
    ((0.9609776)*( base + ci ) - 2.91  - calc_employee_earning(base)).round(2)

  end
  # this is used for the hire view, to calculate the subtotal and our fee + iva
  def calc_hire_view price
    # Constant Increment to keep our loss at minimum
    ci = 10
    iva = 1.16
    fee = (((price * 0.1) + ci) * iva).round(2)
    subtotal = ((price * 0.9) * iva).round(2)
    {"fee": fee, "subtotal": subtotal}
  end

  def order_tax price
    (price * 0.16).round(2)
  end
  ###### These two should always sum 1
  def get_order_fee price
    # Get our fee of base price
    (price * 0.10).round(2)
  end

  def calc_employee_earning base
    (base * 0.9).round(2)
  end
  ######
  # the difference with the one above is that this one calculates all the orders minus fees and taxes
  def calc_employee_orders_earning(orders_total, orders_count)
    (((orders_total / 116) * 100 - (10 * orders_count)) * 0.90).round(2)
    # (45/58) * orders_total - 9 * orders.count
  end

  def calc_openpay_tax (order_total)
    openpay_fee = 0.029 #percent
    openpay_base = 2.5 #MXN pesos
    pre_iva = (order_total * openpay_fee + openpay_base).round(2)
    tax_iva = pre_iva * 0.16
    (pre_iva + tax_iva).round(2)
  end

  # Get toal price of order, with taxes included
  def purchase_order_total price
    const_added = price + 10
    iva = order_tax(const_added)
    (const_added + iva).round(2)
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

  def print_earnings base
    ci = 10
    jalecitos_earning =  ((ci - 2.9) - (ci * 0.0390224) - (0.0390224 * base) + get_order_fee(base)).round(2)
    openpay_earning = (purchase_order_total(base) * 0.03364 + 2.9).round(2)
    p "base + iva = #{purchase_order_total(base)}"
    p "openpay = #{openpay_earning}"
    p "jalecitos = #{jalecitos_earning}"
    return true
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
        <meta name='description' content='Se solicita #{@request.profession} en #{@request.location} para #{@request.name}. Regístrate hoy en Jalecitos para encontrar trabajo.'>
        <meta name='keywords' content='#{@request.location},#{@request.profession},#{@request.tag_list.join(',')}'>
        <meta name='category' content='#{@request.category.name}'>".html_safe
    elsif current_page?( root_path ) && params[:query]
        "<title>Encuentra las mejores oportunidades de trabajo o Expertos para contratar  en línea utilizando Jalecitos</title>
        <meta name='description' content='Necesitas trabajo o encontrar a un experto para alguna necesidad? Utiliza Jalecitos para encontrar empleo o expertos.'>
        <meta name='keywords' content='encontrar, trabajo, empleos, expertos, internet'>
        <meta name='category' content='Trabajo, Empleo'>".html_safe
    else
        "<title>Jalecitos | Encontrar trabajo por internet nunca ha sido tan fácil</title>
        <meta name='description' content='Conoce los mejores expertos que puedes contratar por Jalecitos. Si eres experto, ¡encuentra trabajo hoy utilizando nuestra aplicación!'>
        <meta name='keywords' content='Contratar expertos de confianza, contratar expertos por internet, contratar expertos México'>".html_safe
    end
  end

  def star_display_helper number
    decimal = number % 1
    if number == 0
      "<h6>Sin reseñas</h6>".html_safe
    else
      rounded = number.round(1)
      html = ""
      #number of complete stars
      number.to_i.times do
        html << image_tag("star-on.svg", title: rounded)
      end
      #if has decimal...
      if decimal > 0
        html << image_tag("star-off.svg", title: rounded) if decimal < 0.25

        html << image_tag("star-half.svg", title: rounded) if decimal.between?( 0.25, 0.75 )

        html << image_tag("star-on.svg", title: rounded) if decimal > 0.75
      end
      #stars that doesnt have
      ( (5-number).to_i ).times do
        html << image_tag("star-off.svg", title: rounded)
      end
      #return it
      html.html_safe
    end
  end

  def score_average us, return_number=true
    if us.employee_score_times == 0.0 && us.employer_score_times == 0.0 && return_number == true
      0.0
    elsif us.employee_score_times == 0.0 && us.employer_score_times == 0.0 && return_number != true
      "N/A"
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
    <link rel='apple-touch-icon' sizes='57x57' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-57x57.png' />
    <link rel='apple-touch-icon' sizes='72x72' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-72x72.png' />
    <link rel='apple-touch-icon' sizes='76x76' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-76x76.png' />
    <link rel='apple-touch-icon' sizes='114x114' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-114x114.png' />
    <link rel='apple-touch-icon' sizes='120x120' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-120x120.png' />
    <link rel='apple-touch-icon' sizes='144x144' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-144x144.png' />
    <link rel='apple-touch-icon' sizes='152x152' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-152x152.png' />
    <link rel='apple-touch-icon' sizes='180x180' href='https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/pwa_icons/ios/apple-touch-icon-180x180.png' />
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

  def get_invoice uuid
    openpay_url = ENV.fetch("RAILS_ENV") == "production" ? "api.openpay.mx" : "sandbox-api.openpay.mx"
    uri = URI("https://#{openpay_url}/v1/#{ENV.fetch("OPENPAY_MERCHANT_ID")}/invoices/v33/#{uuid}")
    header = {"Content-Type" => "application/json"}
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, header)
    req.basic_auth ENV.fetch("OPENPAY_PRIVATE_KEY"), ''
    res = https.request(req)
    JSON.parse(res.body)
  end
end
