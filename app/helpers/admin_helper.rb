module AdminHelper
  def status_icon_admin_helper gig
    if gig.published? || gig.draft?
      link_to(icon("fas","close", title: "banear"), ban_gig_path(gig))
    else
      link_to(icon("fas","check", title: "autorizar"), ban_gig_path(gig))
    end
  end
end
