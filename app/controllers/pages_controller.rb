class PagesController < ApplicationController
  before_action :admin_redirect, only: :home
  layout :set_layout
  def home
    if current_user && params[:query]
      if (params[:model_name] == "gigs")
        includes = [:search_gigs_packages, :user]
        status = "published"
        @search_gigs = search(Gig, includes, status)
      else
        includes = [:user]
        status = "open"
        @search_requests = search(Request, includes, status)
      end
    elsif current_user
        @verified_gigs = Gig.includes(:gigs_packages, :user).published.where(category: 1).first(5)
        @recommended_gigs = Gig.includes(:gigs_packages, :user).published.where(category: 2).first(5)
        @featured_gigs = Gig.includes(:gigs_packages, :user).published.where(category: 3).first(5)
    end
  end

  def requests_index
    @requests = Request.includes(:user).friendly.order(created_at: :desc)
    render "requests"
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(:controller => 'admins', :action => 'dashboard') : nil
  end

  def set_layout
    (current_user)? 'logged' : 'guest'
  end

  def search model, includes, status
    (params[:query] == "")? query = "*" : query = params[:query]
    if params[:category_id] != "" && params[:location] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id], location: params[:location]}, page: params[:page], per_page: 15
    elsif params[:category_id] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id]}, page: params[:page], per_page: 15
    elsif  params[:location] != ""
      model.search query,includes: includes, where: {status: status, location: params[:location]}, page: params[:page], per_page: 15
    else
      model.search query,includes: includes, where: {status: status}, page: params[:page], per_page: 15
    end
  end

end
