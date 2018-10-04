module ApplicationHelper

  def nav_links_helper
    if logged_in?(:user)
      render 'shared/nav_links_user'
    else
      render 'shared/nav_links_guest'
    end
  end

end
