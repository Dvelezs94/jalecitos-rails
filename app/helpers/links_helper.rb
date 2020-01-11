module LinksHelper
  def make_links val
    regexp = /((https?:\/\/)(\w+\.)+[A-Za-z]+[^\s]*|(www\.)(\w+\.)+[A-Za-z]+[^\s]*|(\w+\.)+(com|org|net|co|us|mx)((\?|\/)[^\s]*)?)/
    #EXPLANATION OF REGEX
    #Look at the two greps | delimiting options in the regex:
    # i made 3 options to match url:
    #1: if url has https, then match url with any only-word extension and then match everything until space [^\s]* because it may have params
    #2: if  url has www, same behaviour as first
    #3: if there is some word that has a dot next to it, then just make url if it is a common extension, then check if next char is / or ?, .NOTE: google.coma just make link google.com

    #this still matches https://www.com or www.www.com or www.com, but whatsapp and other sites also have this behaviour. Its nonsense trying to make code harder, in 99.9% of cases it would be wasting of time checking for that stuff
    puts "X"*100
    puts val
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
