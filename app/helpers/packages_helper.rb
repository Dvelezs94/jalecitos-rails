module PackagesHelper
  def package_form_url_helper
    if params[:action] == "edit_packages" || params[:action] == "update_packages"
      update_packages_path
    else
      packages_path
    end
  end
end
