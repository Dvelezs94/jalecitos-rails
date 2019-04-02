module PackagesHelper
  def package_form_url_helper
    if params[:action] == "edit" || params[:action] == "update"
      update_packages_path
    else
      packages_path
    end
  end
end
