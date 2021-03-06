module ApplicationHelper

  private

  def banned_notification
    if current_user.banned?
      render "shared_user/banned_notification"
    end
  end

  def distance model, lat, lng
    current_location = Geokit::LatLng.new(lat, lng)
    destination = "#{model.lat},#{model.lng}"
    current_location.distance_to(destination, :units => :kms).to_i.to_s(:delimited, delimiter: ' ', separator: '.')  + " kms"
  end

  def city_slug element
    strings = element.address_name.split(",")
    slug = (element.address_name.present?)? (strings.length > 3)? strings[-3..-2].join(",").gsub(/[0-9]/, '').strip: strings[-2].gsub(/[0-9]/, '').strip : "México"
    return slug.parameterize
  end

  def is_mobile?
    cookies.permanent.signed[:mb].present?
  end

  def not_rated_gig(gig)
    review = Review.find_by(reviewable: gig, giver: current_user, order_id: nil)
    (review.present?)? false : true
  end

  def prof_and_loc model  #this function is used in home and queries
    profession = model.profession.present? ? model.profession : "Sin profesión"
    if current_user #if user
      if model.lat && current_user.address_name.present?#both model and user have location
        profession + " (#{distance(model, current_user.lat, current_user.lng)})"
      else
        "#{profession} (#{model.address_name || "Sin dirección"})"
      end
    else # is guest
      if model.lat && params[:lat].present? #guest accepted location
        profession + " (#{distance(model, params[:lat].to_f, params[:lon].to_f)})"
      else#element has other location (or i didnt had set one location or home)
        "#{profession} (#{model.address_name || "Sin dirección"})"
      end
    end
  end

  def gig_carousel title, variable_name, partial='shared/gigs/carousel', liked=false
    collection = instance_variable_get("@"+variable_name.to_s)
    if liked == false
      render(partial, title: title, gigs: collection, param_name: variable_name) if collection.present?
    else
      render(partial, title: title, gigs: @liked_gigs_items, param_name: variable_name) if @liked_gigs_items.present?
    end
  end

  def req_carousel title, variable_name, partial='shared/requests/carousel'
    collection = instance_variable_get("@"+variable_name.to_s)
    render(partial, title: title, requests: collection, param_name: variable_name) if collection.present?
  end

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
      end
      notification_generator_helper msg, flash_type
    end
  end

  def notification_generator_helper msg, flash_type
    if flash_type == :error
      type = "error"
    elsif flash_type == :success
      type = "success"
    elsif flash_type == :notice
      type = "info"
    else
      type = "warning"
    end
    ("<script>toastr." + type + "('"+ msg + "')</script>").html_safe
  end

  def image_display_helper image, yt_url #used in min versions
    if image.nil? && ! yt_url.present?
      image_path("service.svg")
    elsif image.nil?
      YouTubeRails.extract_video_image(yt_url, "medium")
    elsif image.file.extension == "gif"
      image.url
    else
      image.url(:carousel)
    end
  end


  def tag_variable_helper
     (params[:controller] == 'gigs')? 'gig[tag_list]' : 'request[tag_list]'
  end


  def avatar_display_helper image
    if image.nil?
      image_path("profile.svg")
    else
      image
    end
  end

  def opposite_conversation_user(conversation, current_user)
    @opposite_user = conversation.sender == current_user ? conversation.recipient : conversation.sender
  end

  def url_generator_helper (notification, object)
    case
    when notification.query_url.present?
      finance_path(:table => notification.query_url)
    when object.class == Request
      request_path(object.slug)
    when object.class ==  Offer || object.class ==  Package
      root_path(:notification => notification.id)
    when object.class == Dispute
       order_dispute_path(object.order.uuid, object)
    when object.class == Reply
       order_dispute_path(object.dispute.order.uuid, object.dispute)
    when object.class == TicketResponse
       ticket_path(object.ticket)
    when object.class == Ticket
       ticket_path(object)
    end
  end

  def build_notification_text (notification, object, html=true)
    text = ""
    if /[[:lower:]]/.match(notification.action[0]) #need to have user because isnt capital
      text = "<strong>#{notification.user.slug}</strong> #{notification.action} "
      case
      when object == nil #deleted gig (package also)
        text += "un <strong>Jale eliminado</strong>"
      when object.class == Request
        text += "en el pedido <strong>#{object.title}</strong>"
      when object.class == Package
        text += "el jale <strong>#{object.gig.title}</strong> por el paquete <strong>"+ I18n.t("gigs.packages.#{object.pack_type}") +"</strong>"
      when object.class == Dispute
        text += "en la orden <strong>#{object.order.uuid}</strong>"
      when object.class == Offer
        text += "en el pedido <strong>#{object.request.title}</strong>"
      when object.class == Reply
        text += "en la disputa de la orden <strong>#{object.dispute.order.uuid}</strong>"
      when object.class == TicketResponse
        text += "en el ticket <strong>#{object.ticket.title}</strong>"
      when object.class == Ticket
        text += "el ticket <strong>#{object.title}</strong>"
      end
    else
      text = "#{notification.action} "
      case
      when notification.action == "Se ha validado" && object == nil #when a request has a validated payment, it cant be deleted, so just package can have this situation
        text += "el pago del <strong>Jale eliminado</strong>"
      when notification.action == "Se ha validado" && object.class == Package
        text += "el pago del jale <strong>#{object.gig.title}</strong> por el paquete <strong>"+ I18n.t("gigs.packages.#{object.pack_type}") + "</strong>"
      when notification.action == "Se ha validado" && object.class == Offer
        text += "el pago del pedido <strong>#{object.request.title}</strong>"
      when notification.action == "Se ha finalizado" && object == nil #deleted gig (package also)
        text += "un <strong>Jale eliminado</strong>"
      when notification.action == "Se ha finalizado" && object.class == Package
        text += "el jale <strong>#{object.gig.title}</strong> por el paquete <strong>"+ I18n.t("gigs.packages.#{object.pack_type}") + "</strong>"
      when notification.action == "Se ha finalizado" && object.class == Offer
        text += "el pedido <strong>#{object.request.title}</strong>"
      when notification.action == "Se te ha reembolsado" && object.class == Order
        text += "la orden <strong>#{object.uuid}</strong> por la cantidad de <strong>$#{object.total} MXN</strong>. Ten en cuenta que puede tardar hasta 72 hrs para aparecer en tu cuenta bancaria."
      when (notification.action == "Se ha reembolsado" || notification.action == "Se te reembolsará" ) && object.class == Order
        text += "la orden <strong>#{object.uuid}</strong>"
      when notification.action == "El talento" && object.class == Order
        text += "ya no se encuentra disponible, se te reembolsará la orden <strong>#{object.uuid}</strong>, intenta contratar a alguien más"
      when notification.action == "Se abrió" && object.class == Ticket
        text += "el ticket <strong>#{object.title}</strong>"
      end
    end
    if html == true
      text.html_safe
    else
      ActionView::Base.full_sanitizer.sanitize(text)
    end
  end

  def form_method_helper
    actions = ["edit", "update"]
    if actions.include?(params[:action])
      :patch
    else
      :post
    end
  end

  def seo_location(element)
    if element.address_name.present?
      element.location
    else
      "México"
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
        html << image_tag("star-on.svg", title: rounded, class: "review-star")
      end
      #if has decimal...
      if decimal > 0
        html << image_tag("star-off.svg", title: rounded, class: "review-star") if decimal < 0.25

        html << image_tag("star-half.svg", title: rounded, class: "review-star") if decimal.between?( 0.25, 0.75 )

        html << image_tag("star-on.svg", title: rounded, class: "review-star") if decimal > 0.75
      end
      #stars that doesnt have
      # ( (5-number).to_i ).times do
      #   html << image_tag("star-off.svg", title: rounded, class: "review-star")
      # end
      #return it
      html.html_safe
    end
  end

  def one_star_disp_help gig
    html = ""
     if gig.score_times > 0
       html += '<i data-feather="star" class="feather-12 tx-warning filled"></i>'
       html += "<span class='tx-warning'> #{gig.score_average.round(1)} <small class='tx-gray-600'>(#{gig.score_times})</small></span>"
    else
      html += '<i data-feather="star" class="feather-12 tx-gray-600 filled"></i>'
      html += "<span> <small class='tx-gray-600'>(0)</small></span>"
    end
    html.html_safe
  end

  def ios_pwa_tags
    "<meta name='apple-mobile-web-app-capable' content='yes'>
    <meta name='apple-mobile-web-app-status-bar-style' content='default'>
    <link rel='apple-touch-icon' sizes='57x57' href='#{image_path('iphone_icons/logomark-57.png')}'/>
    <link rel='apple-touch-icon' sizes='72x72' href='#{image_path('iphone_icons/logomark-72.png')}'/>
    <link rel='apple-touch-icon' sizes='76x76' href='#{image_path('iphone_icons/logomark-76.png')}'/>
    <link rel='apple-touch-icon' sizes='114x114' href='#{image_path('iphone_icons/logomark-114.png')}'/>
    <link rel='apple-touch-icon' sizes='120x120' href='#{image_path('iphone_icons/logomark-120.png')}'/>
    <link rel='apple-touch-icon' sizes='144x144' href='#{image_path('iphone_icons/logomark-144.png')}'/>
    <link rel='apple-touch-icon' sizes='152x152' href='#{image_path('iphone_icons/logomark-152.png')}'/>
    <link rel='apple-touch-icon' sizes='180x180' href='#{image_path('iphone_icons/logomark-180.png')}'/>".html_safe
  end

  def gig_review_google
    "<script type='application/ld+json'>
{
  '@context' : 'https://schema.org/',
  '@type': 'EmployerAggregateRating',
  'itemReviewed': {
    '@type': 'Organization',
    'name' : '#{@gig.title}',
    'sameAs' : '#{request.original_url}'
  },
  'ratingValue': '#{@gig.score_average}',
  'bestRating': '5',
  'worstRating': '1',
  'ratingCount' : '#{@gig.score_times}'
}
</script>".html_safe
  end

  def platform_redirect_root_path
    root_path
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

  def the_gig_path gig, format = nil
    if format == nil
      gig_path(city_slug(gig), gig.category.name.parameterize,gig.slug)
    else
      gig_path(city_slug(gig), gig.category.name.parameterize,gig.slug, format: format)
    end
  end
  def the_gig_url gig, format = nil
    if format == nil
      gig_url(city_slug(gig), gig.category.name.parameterize,gig.slug,:protocol => 'https')
    else
      gig_url(city_slug(gig), gig.category.name.parameterize,gig.slug, format: format,:protocol => 'https')
    end
  end
end
