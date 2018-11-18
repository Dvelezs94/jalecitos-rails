module GigStatus

  def toggle_status
    check_if_banned
    check_first_package
    if flash[:error]
      redirect_to user_path(current_user.slug)
    else
      change_status
      flash[:success] = "Se ha cambiado el estado del Gig exitosamente"
      redirect_to user_path(current_user.slug)
    end
  end

  def ban_gig
    (@gig.published? || @gig.draft?) ? @gig.banned! : @gig.draft!
    redirect_to root_path, notice: "Gig status has been updated"
  end

  private

  def check_first_package
    (@gig.gig_first_pack[0].nil? || @gig.gig_first_pack[0].name == "" || @gig.gig_first_pack[0].description == "" || @gig.gig_first_pack[0].price == nil || @gig.gig_first_pack[0].price < 100)  ? flash[:error]='Este Gig no contiene ningún paquete' : nil
  end

  def change_status
    (@gig.draft?) ?  @gig.published! : @gig.draft!
  end

  def check_if_banned
     (@gig.banned?) ? flash[:error]='Este Gig está baneado' : nil
  end

end
