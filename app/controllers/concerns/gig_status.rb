module GigStatus

  def toggle_status
    check_if_banned(@gig)
    check_packages_count(@gig)
    if flash[:error]
      redirect_to gigs_path
    else
      change_status(@gig)
      redirect_to gigs_path, notice: "Se ha cambiado el estado del Gig exitosamente"
    end
  end

  def ban_gig
    if @gig.published? || @gig.draft?
      @gig.banned!
    else
      @gig.draft!
    end
    redirect_to root_path, notice: "Gig status has been updated"
  end
  private
  def check_status
    if @gig.banned?
      redirect_to gigs_path, notice: 'Este Gig está baneado'
    end
  end

  def check_packages_count gig
    if gig.packages.count == 0
      flash[:error]='Este Gig no contiene ningún paquete'
    end
  end
  def change_status gig
    if gig.draft?
        gig.published!
    else
        gig.draft!
    end
  end

  def check_if_banned gig
    if gig.banned?
      flash[:error]='Este Gig está baneado'
    end
  end

end
