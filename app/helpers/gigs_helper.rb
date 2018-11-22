module GigsHelper

  def gig_form_url_helper
    if params[:action] == "edit" || params[:action] == "update"
      user_gig_path(current_user.slug,@gig)
    else
      user_gigs_path(current_user.slug)
    end
  end

   def status_text_helper gig
     if gig.published?
       fa_icon("eye-slash", class: "fa-lg gig_action_icon",title: "Ocultar")
     else
       fa_icon("eye", class: "fa-lg gig_action_icon",title: "Publicar")
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
