module GigStatus

  def toggle_status
    if @gig.banned?
      redirect_to gigs_path, notice: 'This Gig is banned'
    end
    if @gig.draft?
        @gig.published!
    else
         @gig.draft!
   end
   redirect_to gigs_path, notice: "Gig status has been updated"
  end

  def ban_gig
    if @gig.published? || @gig.draft?
      @gig.banned!
    else
      @gig.draft!
    end
    redirect_to root_path, notice: "Gig status has been updated"
  end

  def check_status
    if @gig.banned?
      redirect_to gigs_path, notice: 'This Gig is banned'
    end
  end

end
