module DescriptionRestrictions
  private
  def decodeHTMLEntities text, keep=true
    entities = [
        ['amp', '&'],
        ['apos', '\''],
        ['#x27', '\''],
        ['#x2F', '/'],
        ['#39', '\''],
        ['#47', '/'],
        ['lt', '<'],
        ['gt', '>'],
        ['nbsp', ' '],
        ['quot', '"']
    ];
    if keep
      entities.each do |entity|
        text = text.gsub('&'+entity[0]+';', entity[1]);
      end
    else
      entities.each do |entity|
        text = text.gsub('&'+entity[0]+';', "");
      end
    end
    text
  end

  def count_without_html
    #all the html is erased
    noHtml = no_html(description)
    #the entities are encoded to its real char
    noHtml_real_char = decodeHTMLEntities(noHtml)
    errors.add(:base, "Sólo se admiten como máximo 1000 caracteres") if noHtml_real_char.length > 1000
  end

  def description_length
    #the entities are encoded to its real char
    real_char = decodeHTMLEntities(description)
    errors.add(:base, "La descriptión contiene demasiados efectos de texto") if real_char.length > 2000
  end

  def no_html text, keep_a_space=false
    (keep_a_space)? text.gsub(/<[^>]*>/, " ") : text.gsub(/<[^>]*>/, "")
  end

end
