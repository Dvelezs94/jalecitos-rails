module GigsHelper

  def gig_form_url_helper
    if params[:action] == "edit"
      user_gig_path(current_user.slug,@gig)
    else
      user_gigs_path(current_user.slug)
    end
  end

  def gig_form_method_helper
    if params[:action] == "edit"
      :patch
    else
      :post
    end
  end

   def status_text_helper gig
     if gig.published?
       "Ocultar"
     else
       "Publicar"
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
