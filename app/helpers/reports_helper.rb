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

  def reportable_type object
    if object.class == User
      "Usuario"
    elsif object.class == Gig
      "Anuncio"
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

  def object_url object
    if object.class == User
      user_path(object.slug)
    elsif object.class == Gig
      the_gig_path(object)
    else
      request_path(object.slug)
    end
  end
  def create_ban_url report_id
    url = bans_path(report_id: report_id)
  end
end
