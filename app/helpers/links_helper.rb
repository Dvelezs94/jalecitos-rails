module LinksHelper
  def make_links val
    regexp = /((https?:\/\/)(\w+\.)+[A-Za-z]+|(www\.)(\w+\.)+[A-Za-z]+|(\w+\.)+(com|org|net|co|us|mx))(?:(?=(\/|\?|\s))[^\s]*|(?!x)x)/
    #EXPLANATION OF REGEX
    #Look at the two greps | delimiting options in the regex:
    # i made 3 options to match url:
    #1: if url has https, then match url with any extension
    #2: if  url has www, same behaviour as first
    #3: if there is some word that has a dot next to it, then just make url if it is a common extension
    #after verifying its an url, match until space [^\s] if next char is / or ? because the url can have parameters, and even if it ends there \s, because it then returns true.
    #if the url doesnt have http(s), or www, and it has more chars after extension and the first isnt an / or ?, it means its extension is strange, so with (?!x)x it returns false (idk why but it always does). All this is useful so google.coma doesnt take as link
    #anyway the strange extensions pass the test when has http(s) or www.

    #this still matches https://www.com or www.www.com or www.com, but whatsapp and other sites also have this behaviour. Its nonsense trying to make code harder, in 99.9% of cases it would be wasting of time checking for that stuff

    #old regex /(https?:\/\/)?(www\.)?(\w+\.)+[A-Za-z]+[^\s]*/ removed it becuse it matches with stuff like jajaj.yo, if the users dont separate words after dot, then we would have fake urls
    val.gsub(regexp) { |url|
      url_parsed = URI.parse(url)
      link_url = ( url_parsed.scheme )? url : "http://" + url
      "<a href='#{URI.parse(link_url)}'target='_blank'>#{url}</a>"
    }
  end
end
