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

   def status_text_helper gig
     if gig.published?
       "Ocultar"
     else
       "Publicar"
     end
   end

   def status_options_helper form
     if @gig.banned?
       '<p>This gig is banned<p>'.html_safe
     else
       render 'status_options', form: form
     end
   end


   def checked_helper option_status
     if @gig.status == option_status
       opions = {checked: true}
     else
       opions = {checked: false}
     end
   end
end
