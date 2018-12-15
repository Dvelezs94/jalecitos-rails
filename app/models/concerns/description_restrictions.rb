module DescriptionRestrictions
  private
  def decodeHTMLEntities text
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
    entities.each do |entity|
      text = text.gsub('&'+entity[0]+';', entity[1]);
    end
    text
  end

  def count_without_html
    #all the html is erased
    noHtml = description.gsub(/<[^>]*>/, "")
    #the entities are encoded to its real char
    noHtml_real_char = decodeHTMLEntities(noHtml)
    errors.add(:base, "Sólo se admiten como máximo 1000 caracteres") if noHtml_real_char.length > 1000
  end

  def description_length
    #the entities are encoded to its real char
    real_char = decodeHTMLEntities(description)
    errors.add(:base, "La descriptión contiene demasiados efectos de texto") if real_char.length > 2000
  end
end
