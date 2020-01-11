module LinksHelper
  def make_links val
    regexp = /((https?:\/\/)(\w+\.)+[A-Za-z]+[^\s]*|(www\.)(\w+\.)+[A-Za-z]+[^\s]*|(\w+\.)+(com|org|net|co|us|mx|info)(\?|\/)[^\s]*|(\w+\.)+(com|org|net|co|us|mx)((?=[^a-zA-Z0-9])|\z))/
    #EXPLANATION OF REGEX
    #Look at the 3 greps | delimiting options in the regex:
    # i made 4 options to match url:
    #1: if url has https, then match url with any only-word extension and then match everything until space [^\s]* because it may have params
    #2: if  url has www, same behaviour as first
    #3: if there is some word that has a dot next to it, then just make url if it is a common extension, then check if next char is / or ? and keep all params
    #4: is like 3 but it has no params, so it checks that no char of word is next to the link so it can interpret it (\z is for when is located at the end of the string, it fixes bug) stuff "like google.com," is interpreted but google.coma dont

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
