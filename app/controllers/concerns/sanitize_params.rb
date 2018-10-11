module SanitizeParams

  def string_params
    str_par = [:description]
  end

  def sanitized_params
    sanitized_par = gig_params
    string_params.each do |item|
    sanitized_par[item] = Sanitize.fragment(sanitized_par[item],
              :elements => ['li', 'ul', 'ol', 'bold', 'em', 'strong', 'del', 'a'])
    end
    sanitized_par
  end

end
