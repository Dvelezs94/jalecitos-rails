module PackagesHelper
  def package_form_url_helper
    if params[:action] == "new"
      gig_packages_path(params[:gig_id], @package)
    else
      update_gig_packages_path(@gig)
    end
  end
end
