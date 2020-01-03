module LinksHelper
  def make_links val
    regexp = /(https?:\/\/)?[\w,-]*\.\w+(\.\w+)*((?:\/|\?)[^\s]*)?/
    val.gsub(regexp) { |url|
      url_parsed = URI.parse(url)
      link_url = ( url_parsed.scheme )? url : "http://" + url
      "<a href='#{URI.parse(link_url)}'target='_blank'>#{url}</a>"
    }
  end
end
