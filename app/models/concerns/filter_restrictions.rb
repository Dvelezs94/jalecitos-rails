module FilterRestrictions
  private
  def no_multi_spaces text
    text.gsub(/ +/, " ")
  end

  def no_special_chars text
    text.gsub(/[[:punct:]]/, ' ') # [[:punct:]] is [`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]
  end

  def remove_uris(text)
    regexp = /(https?:\/\/)?(www\.)?(\w+\.)+[A-Za-z]+[^\s]*/ #search this regex in other def
    text.gsub(regexp) { |url|
      "" #removes the links
    }
  end

  def remove_nexus text
    nexus.each do |nex|
      text = text.gsub(/( |\A)#{nex}(?=( |\z))/ , ' ') #i can consider just spaces because special chars have been replaced for space#\z means that the word was the last in the string
      #[:punct:] Punctuation characters: any printable character excluding aplhanumeric or space
      #the char after nex is question because if not, when nexus one after another, one doesnt get deleted
      # text.gsub(/([[:punct:]]| )#{nex}(?=([[:punct:]]| |\z))/ , ' ') this considers the special chars, but i delete them before, so i dont need something very complicated
    end
    return text
  end

  #also used in filter_restrictions so elastic dont query nexus
  def nexus #i dont need with uppercae because i made it downcase before, dont need with accent because i removed it before
    [
      "de", "del", "lo", "los", "la","las", "le", "les", "a", "e", "y", "o", "u", "que", "porque", "ti",
      "pero", "mas", "sin embargo", "no obstante", "al contrario", "si bien", "ni", "ya", "o bien", "es decir", "es",
      "o sea", "pues", "puesto que", "por","tanto", "como", "asi", "aun","aunque", "bien que", "si", "con", "tal", "segun",
      "para", "todavia"
    ]
  end
end
