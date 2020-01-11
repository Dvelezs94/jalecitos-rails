module LinksHelper
  def make_links val
    regexp = /((https?:\/\/)(\w+\.)+[A-Za-z]+[^\s]*|(www\.)(\w+\.)+[A-Za-z]+[^\s]*|(\w+\.)+(com|org|net|co|us|mx)+[^\s]*)/
    #Look at the two greps | delimiting options in the regex:
    # i made 3 options to match url:
    #1: if url has https, then match url with any extension
    #2: if  url has www, same behaviour as first
    #3: if there is some word that has a dot next to it, then just make url if it is a common extension
    #this still matches https://www.com, but whatsapp and other sites also have this behaviour. Its nonsense trying to make code harder, in 99.9% of cases it would be wasting of time checking for that stuff

    #old regex /(https?:\/\/)?(www\.)?(\w+\.)+[A-Za-z]+[^\s]*/ removed it becuse it matches with stuff like jajaj.yo, if the users dont separate words after dot, then we would have fake urls
    val.gsub(regexp) { |url|
      url_parsed = URI.parse(url)
      link_url = ( url_parsed.scheme )? url : "http://" + url
      "<a href='#{URI.parse(link_url)}'target='_blank'>#{url}</a>"
    }
  end
end
