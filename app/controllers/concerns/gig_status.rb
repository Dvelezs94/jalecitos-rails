module GigStatus

  private

  def check_first_package
    flash[:error]='Este Jale no contiene ningún paquete' if (@gig.gig_first_pack[0].nil? || @gig.gig_first_pack[0].name == "" || @gig.gig_first_pack[0].description == "" || @gig.gig_first_pack[0].price == nil || @gig.gig_first_pack[0].price < 100)
  end

  def change_status
    (@gig.draft?) ?  @gig.published! : @gig.draft!
  end

  def check_if_banned
    flash[:error]='Este Jale está suspendido' if @gig.banned?
  end

end
