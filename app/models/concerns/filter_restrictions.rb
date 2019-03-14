module FilterRestrictions
  private
  def no_multi_spaces text
    text.gsub(/ +/, " ")
  end

  def no_special_chars text
    text.gsub(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/, '')
  end

  def remove_uris(text)
  uri_regex = %r"((?:(?:[^ :/?#]+):)(?://(?:[^ /?#]*))(?:[^ ?#]*)(?:\?(?:[^ #]*))?(?:#(?:[^ ]*))?)"
    text.split(uri_regex).collect do |s|
      unless s =~ uri_regex
        s
      end
    end.join
  end
end
