module AdminHelper
  def status_icon_admin_helper gig
    if gig.published? || gig.draft?
      link_to(icon("fas","close", title: "banear"), ban_user_gig_path(gig.user_id, gig))
    else
      link_to(icon("fas","check", title: "autorizar"), ban_user_gig_path(gig.user_id, gig))
    end
  end
end
