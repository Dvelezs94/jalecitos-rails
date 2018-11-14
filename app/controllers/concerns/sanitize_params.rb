include DescriptionRestrictions
module SanitizeParams
  def string_params
    str_par = [:description]
  end

  def sanitized_params model_params
    sanitized_par = model_params

    string_params.each do |item|
      permitted_html = Sanitize.fragment(sanitized_par[item],
              :elements => ['li', 'ul', 'ol', 'bold', 'em', 'strong', 'del', 'a', 'br'])
      permitted_html = permitted_html.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '').gsub(/^(\s*<br( \/)?>)*|(<br( \/)?>\s*)*$/, '')
      sanitized_par[item] = decodeHTMLEntities(permitted_html)

    end
    sanitized_par
  end

end
