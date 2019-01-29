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
    if params[:query]
        render 'shared/query/homepage_query'
    elsif has_role?(:user)
       render 'shared_user/root/homepage'
    else
       render 'shared_guest/guest_page'
    end
  end

  def query_home_or_profile_helper gig
    if params[:query]
      number_to_currency(purchase_order_total(gig.search_gigs_packages.first.price), precision: 2)
    elsif params[:controller]=="pages" && gig.gigs_packages.first.present?
      number_to_currency(purchase_order_total(gig.gigs_packages.first.price), precision: 2)
    elsif params[:controller]=="users" && gig.packages.first.present?
      number_to_currency(purchase_order_total(gig.packages.first.price), precision: 2)
    else
      "Indefinido"
    end
  end

end
