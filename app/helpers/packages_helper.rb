module PackagesHelper
  def package_form_url_helper
    if params[:action] == "edit_packages" || params[:action] == "update_packages"
      update_user_gig_packages_path(current_user.slug,@gig)
    else
      user_gig_packages_path(current_user.slug,params[:gig_id])
    end
  end
end
