module RefererFunctions
  def referer_params (referer_url)
    url = referer_url
    uri = URI.parse(url)
    CGI.parse(uri.query)
  end
end
