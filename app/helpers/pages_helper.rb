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
    if has_role?(:user)
       render 'shared_user/root/homepage'
    else
       render 'shared_guest/root/homepage'
    end
  end

  def query_home_or_profile_helper gig
    if params[:query]
      number_to_currency(purchase_order_total(starting_price(gig.search_gigs_packages.first)), precision: 2)
    elsif params[:controller]=="pages" && ! gig.gigs_packages.first.nil?
      number_to_currency(purchase_order_total(starting_price(gig.gigs_packages.first)), precision: 0)
    elsif params[:controller]=="users" && ! gig.prof_pack.first.nil?
      number_to_currency(purchase_order_total(starting_price(gig.prof_pack.first)), precision: 2)
    elsif params[:controller]=="gigs" && params[:action]=="show" && ! gig.related_pack.first.nil?
      number_to_currency(purchase_order_total(starting_price(gig.related_pack.first)), precision: 2)
    else
      "Indefinido"
    end
  end

  def starting_price pack
    pack.min_amount.present? ? pack.price*pack.min_amount : pack.price
  end

end
