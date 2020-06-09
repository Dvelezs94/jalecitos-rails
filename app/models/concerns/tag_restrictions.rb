module TagRestrictions
  private
  def maximum_amount_of_tags
    number_of_tags = tag_list_cache_on("tags").uniq.length
    errors.add(:base, "Sólo se admiten como máximo 5 etiquetas") if number_of_tags > 20
  end

  def no_spaces_in_tag
    tag_list= tag_list_cache_on("tags")

    tag_list.each do |tag|
      if tag.match(/\s/)
        errors.add(:base, "Cada etiqueta debe contener sólo una palabra")
        break
      end
    end
  end

  def tag_length
    tag_list= tag_list_cache_on("tags")

    tag_list.each do |tag|
      if tag.length > 50
        errors.add(:base, "Cada etiqueta debe contener 50 caracteres como máximo")
        break
      end
    end
  end


end
