module LocationValidation
  private
  def location_syntax
    if location != nil
      valid = location.match(/, MX/)
      errors.add(:base, "La ubicación debe ser una proporcionada en las opciones.") if valid.nil?
    end
  end
end
