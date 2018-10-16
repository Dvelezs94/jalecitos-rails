module GigStatus

  def toggle_status
    check_if_banned
    check_packages_count
    if flash[:error]
      redirect_to user_gigs_path(current_user.slug)
    else
      change_status
      redirect_to user_gigs_path(current_user.slug), notice: "Se ha cambiado el estado del Gig exitosamente"
    end
  end

  def ban_gig
    (@gig.published? || @gig.draft?) ? @gig.banned! : @gig.draft!
    redirect_to root_path, notice: "Gig status has been updated"
  end

  private

  def check_status
    (@gig.banned?) ? redirect_to(gigs_path, notice: 'Este Gig está baneado') : nil
  end

  def check_packages_count
    (@gig.packages.none?) ? flash[:error]='Este Gig no contiene ningún paquete' : nil
  end

  def change_status
    (@gig.draft?) ?  @gig.published! : @gig.draft!
  end

  def check_if_banned
     (@gig.banned?) ? flash[:error]='Este Gig está baneado' : nil
  end

end
