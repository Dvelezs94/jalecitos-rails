module LocationValidation
  private
  def location_syntax
    if location != nil
      valid = location.match(/, México/)
      valid = location.match(/, Mexico/) if valid.nil?
      errors.add(:base, "La ubicación debe ser una proporcionada en las opciones.") if valid.nil?
    end
  end
end
