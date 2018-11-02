module PagesHelper
  #devise
  def resource_name
    :user
  end

  def resource_class
     User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def homepage_content_helper
    if  has_role?(:user) && params[:query]
      render 'shared_user/root/homepage_query'
    elsif has_role?(:user)
       render 'shared_user/root/homepage'
    else
       render 'shared_guest/guest_page'
    end
  end

  def sign_script_helper
    if current_user.nil?
      javascript_include_tag 'sign', 'data-turbolinks-track': 'reload'
    end
  end

  def query_or_home_helper gig
    if params[:query]
      link_to number_to_currency(gig.search_gigs_packages.first.price, precision: 2), user_gig_path(gig.user.slug,gig)
    elsif gig.gigs_packages.first.present?
      link_to number_to_currency(gig.gigs_packages.first.price, precision: 2), user_gig_path(gig.user.slug,gig)
    else
      link_to "Indefinido", user_gig_path(gig.user.slug,gig)
    end
  end

end
