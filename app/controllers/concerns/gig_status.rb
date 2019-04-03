module GigStatus

  private

  def check_first_package
    flash[:error]='Este Jale no contiene ningún paquete' if (@gig.gig_packages[0].nil? || @gig.gig_packages[0].name == "" || @gig.gig_packages[0].description == "" || @gig.gig_packages[0].price == nil || @gig.gig_packages[0].price < 100)
  end

  def change_status
    (@gig.draft?) ?  @gig.published! : @gig.draft!
  end

  def check_if_banned
    flash[:error]='Este Jale está suspendido' if @gig.banned?
  end

end
