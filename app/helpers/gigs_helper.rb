module GigsHelper

  def gig_actions_helper
    if @gig.user_id == current_user.id
      ("<div class='btn-group'>")+
        (" link_to status_text_helper(@gig), toggle_status_user_gig_path(current_user.slug,@gig), class: 'btn btn-sm btn-outline-secondary' unless current_user.nil? || @gig.banned? || current_user.id != @gig.user_id || @gig.gig_first_pack[0].nil?" )+
        ( "link_to 'Editar', edit_user_gig_path(current_user.slug,@gig), class: 'btn btn-sm btn-outline-secondary' if current_user.present? && @gig.user_id == current_user.id" )+
         ("link_to 'Borrar', user_gig_path(current_user.slug,@gig), method: :delete, data: { confirm: '¿Estás seguro de querer borrar este trabajo?' }, class: 'btn btn-sm btn-outline-secondary' if current_user.present? && @gig.user_id == current_user.id")+
      ("</div>").html_safe
    end
  end

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
