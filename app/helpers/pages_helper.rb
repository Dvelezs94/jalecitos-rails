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
      number_to_currency(purchase_order_total(gig.lowest_price), precision: 0)
    elsif params[:controller]=="pages" && gig.lowest_price.present?
      number_to_currency(purchase_order_total(gig.lowest_price), precision: 0)
    elsif params[:controller]=="users" && gig.lowest_price.present?
      number_to_currency(purchase_order_total(gig.lowest_price), precision: 0)
    elsif params[:controller]=="gigs" && params[:action]=="show" && gig.lowest_price.present?
      number_to_currency(purchase_order_total(gig.lowest_price), precision: 0)
    else
      "Indefinido"
    end
  end

end
