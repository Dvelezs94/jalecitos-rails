module ReportsHelper
  def report_options
    [
      ["Uso de palabras ofensivas", "offensive"],
      ["Contenido Sexual", "sexual"],
      ["Violencia", "violence"],
      ["Spam", "spam"],
      ["Engaño o fraude", "fraud"],
      ["Otro", "other"]
     ]
  end

  def report_name object
    if object.class == User
      "Usuario"
    elsif object.class == Gig
      "Jale"
    else
      "Pedido"
    end
  end
  def report_url object
    if object.class == User
      user_report_path(object.slug)
    elsif object.class == Gig
      gig_report_path(object.slug)
    else
      request_report_path(object.slug)
    end
  end
end
