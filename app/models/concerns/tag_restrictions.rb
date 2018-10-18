module TagRestrictions
  extend ActiveSupport::Concern

  def maximum_amount_of_tags
    number_of_tags = tag_list_cache_on("tags").uniq.length
    errors.add(:base, "Sólo se admiten como máximo 5 tags") if number_of_tags > 5
  end
  
end
