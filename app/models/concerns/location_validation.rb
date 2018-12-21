module LocationValidation
  private
  def location_syntax
    if location != nil
      valid = location.match(/, México/)
      (valid.nil?)? valid = location.match(/, Mexico/) : nil
      (valid.nil?)? errors.add(:base, "La ubicación debe ser una proporcionada en las opciones.") : nil
    end
  end
end
