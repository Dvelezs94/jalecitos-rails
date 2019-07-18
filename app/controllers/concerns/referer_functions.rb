module RefererFunctions
  def referer_params (referer_url)
    url = referer_url
    uri = URI.parse(url)
    CGI.parse(uri.query) rescue {}
  end

  def redirect_to_referer(ref_params)
    if ref_params.key?("package_id")
      quantity = ref_params["quantity"].blank? ? nil : ref_params["quantity"][0]
      package = Package.find_by_slug(ref_params["package_id"])
      redirect_to hire_package_path(package, quantity: quantity)
    elsif ref_params.key?("offer_id")
      offer = Offer.find_by_id(ref_params["offer_id"])
      redirect_to hire_request_offer_path(offer.request, offer)
    elsif ref_params.key?("collapse")
      redirect_to configuration_path(collapse: ref_params["collapse"][0])
    else
      redirect_to configuration_path
    end
  end
end
