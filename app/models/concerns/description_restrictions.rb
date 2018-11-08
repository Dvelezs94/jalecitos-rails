module DescriptionRestrictions
  extend ActiveSupport::Concern
  def without_html
    noHtml = description.gsub(/<[^>]*>/, "");
    noHtml = noHtml.strip
    errors.add(:base, "Sólo se admiten como máximo 1000 caracteres") if noHtml.length > 1000
  end
end
