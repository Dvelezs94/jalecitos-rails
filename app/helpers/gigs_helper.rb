module GigsHelper
  def gig_form_url_helper
    actions = ["edit", "update"]
    ( actions.include?(params[:action]) )? the_gig_path(@gig) : gigs_path
  end

   def status_text_helper gig
     (gig.published?)? "<i data-feather='eye-off'></i> Ocultar".html_safe : "<i data-feather='eye'></i> Publicar".html_safe
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
