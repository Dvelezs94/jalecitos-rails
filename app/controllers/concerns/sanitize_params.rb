module SanitizeParams
  def string_params
    str_par = [:description]
  end

  def sanitized_params model_params
    #for each field that needs sanitizing
    string_params.each do |item|
      #Delete all invalid html
      permitted_html = Sanitize.fragment(model_params[item],
              :elements => ['li', 'ul', 'ol', 'bold', 'em', 'strong', 'del', 'br'])
      #Delete all spaces and <br> from start and end of the content
      permitted_html = permitted_html.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '').gsub(/^(\s*<br( \/)?>)*|(<br( \/)?>\s*)*$/, '')
      #Save the string, notice that it can contains more than 1000 chars because the special ones are saved by its entity to not interfere with html_safe
      model_params[item] = permitted_html
    end
    #return sanitized params
    model_params
  end

end
