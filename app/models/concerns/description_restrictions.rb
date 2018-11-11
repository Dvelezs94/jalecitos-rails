module DescriptionRestrictions
  extend ActiveSupport::Concern
  def count_without_html
    noHtml = description.gsub(/<[^>]*>/, "").gsub(/\A[[:space:]]+|[[:space:]]+\z/, '').gsub(/&nbsp;/, ' ')
    errors.add(:base, "Sólo se admiten como máximo 1000 caracteres") if noHtml.length > 1000
  end
end
