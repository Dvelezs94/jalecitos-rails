module PackagesHelper
  def package_form_url_helper
    if params[:action] == "new"
      user_gig_packages_path(current_user.slug,params[:gig_id], @package)
    else
      update_user_gig_packages_path(current_user.slug,@gig)
    end
  end

  def package_form_method_helper
    if params[:action] == "new"
       :post
    else
      :patch
    end
  end
end
