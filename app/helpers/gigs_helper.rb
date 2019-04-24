module GigsHelper
  def gig_form_url_helper
    actions = ["edit", "update"]
    ( actions.include?(params[:action]) )? gig_path(city_slug(@gig.city),@gig) : gigs_path
  end

   def status_text_helper gig
     (gig.published?)? icon("fas","eye-slash", class: "fa-lg gig_action_icon",title: "Ocultar") : icon("fas","eye", class: "fa-lg gig_action_icon",title: "Publicar")
   end

   def checked_helper option_status
     opions = (@gig.status == option_status) ?  {checked: true} : {checked: false}
   end

   def default_gig_img images #used just in min versions
     images.each do |img|
       if img.file.extension.downcase == "gif"
         return img
       end
     end
     #no gifs, so return image, if no images this returns nil also
     return images[0]
   end
end
