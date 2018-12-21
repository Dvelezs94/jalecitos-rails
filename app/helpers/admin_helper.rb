module AdminHelper
  def status_icon_admin_helper gig
    if gig.published? || gig.draft?
      link_to(fa_icon("close", title: "banear"), ban_user_gig_path(gig.user_id, gig))
    else
      link_to(fa_icon("check", title: "autorizar"), ban_user_gig_path(gig.user_id, gig))
    end
  end
end
