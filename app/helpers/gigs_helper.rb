module GigsHelper
  def image_display_helper image
    if image.nil? 
      "http://placehold.it/600x400"
    else
      image
    end
  end

  def confirm_text_helper
      if params[:action] == "new"
        "Crear trabajo"
     else
        "Guardar cambios"
     end
   end
end
