module AdminHelper
  def status_icon_admin_helper gig
    if gig.published? || gig.draft?
      icon = (("<td>")+(link_to content_tag('span', '', class: 'fe fe-close'), ban_gig_path(gig))+("</td>")).html_safe
    else
      icon = (("<td>")+(link_to content_tag('span', '', class: 'fe fe-check'), ban_gig_path(gig))+("</td>")).html_safe
    end
    icon
  end
end
