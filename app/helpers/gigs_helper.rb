module GigsHelper

  def gig_form_url_helper
    if params[:action] == "new" || params[:action] == "create"
      user_gigs_path(current_user.slug)
    else
      user_gig_path(current_user.slug,@gig)
    end
  end

  def gig_form_method_helper
    if params[:action] == "new" || params[:action] == "create"
       :post
    else
      :patch
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
