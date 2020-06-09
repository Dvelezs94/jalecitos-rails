module AdminHelper
  def status_icon_admin_helper gig
    if gig.published? || gig.draft?
      link_to("Banear", ban_gig_path(gig))
    else
      link_to("Autorizar", ban_gig_path(gig))
    end
  end
end
