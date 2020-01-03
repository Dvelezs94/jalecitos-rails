module FilterRestrictions
  private
  def no_multi_spaces text
    text.gsub(/ +/, " ")
  end

  def no_special_chars text
    text.gsub(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/, '')
  end

  def remove_uris(text)
    regexp = /(https?:\/\/)?[\w,-]*\.\w+(\.\w+)*((?:\/|\?)[^\s]*)?/ #search this regex in other def
    text.gsub(regexp) { |url|
      "" #removes the links
    }
  end
end
