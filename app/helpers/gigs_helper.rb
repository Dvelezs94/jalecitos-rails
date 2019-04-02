module GigsHelper

  def gig_form_url_helper
    actions = ["edit", "update"]
    ( actions.include?(params[:action]) )? gig_path(@gig) : gigs_path
  end

   def status_text_helper gig
     (gig.published?)? icon("fas","eye-slash", class: "fa-lg gig_action_icon",title: "Ocultar") : icon("fas","eye", class: "fa-lg gig_action_icon",title: "Publicar")
   end

   def checked_helper option_status
     opions = (@gig.status == option_status) ?  {checked: true} : {checked: false}
   end
end
