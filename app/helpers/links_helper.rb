module LinksHelper
  def make_links val
    regexp = /((https?:\/\/|www\.)(\w+\.)+[A-Za-z]+|(\w+\.)+(com|org|net|co|us|mx|info))((\?|\/)[^\s]*|((?=[^a-zA-Z0-9])|\z))/
    #EXPLANATION OF REGEX
    #There are 3 options in the regex:
    #1: if url has https, then match url with any only-word extension
    #2: if  url has www, same behaviour as first
    #3: The urls without http(s) and www will match only with the most common extensions
    #After matching urls:
    #check if next char is / or ? and keep all params
    #otherwise [^a-zA-Z0-9] checks if char is special or some kind of \s, if it is, then do nothing (accept), if not, just accepts when is the end of string \z
    #\z is for when is located at the end of the string, it fixes bug. stuff like "google.com," passes but google.coma dont

    #this still matches https://www.com or www.www.com or www.com, but whatsapp and other sites also have this behaviour. Its nonsense trying to make code harder, in 99.9% of cases it would be wasting of time checking for that stuff
    val.gsub(regexp) { |url|
      url_parsed = URI.parse(url)
      link_url = ( url_parsed.scheme )? url : "http://" + url
      "<a href='#{URI.parse(link_url)}'target='_blank'>#{url}</a>"
    }
  end

  def safes_content content
    make_links(CGI::escapeHTML(content)).html_safe #escapes html from user and make our links
  end
end
