class PagesController < ApplicationController
  include SetLayout
  before_action :admin_redirect, only: :home
  before_action :pending_review, only: [:home, :finance]
  layout :set_layout
  def home
    if params[:query]
      if (params[:model_name] == "requests")
        includes = [:user]
        status = "open"
        @search = search(Request, includes, status)
      else
        includes = [:search_gigs_packages, :user]
        status = "published"
        @search = search(Gig, includes, status)
      end
    elsif current_user
        @verified_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 1}, order: {created_at: :desc}, limit: 5)
        @recommended_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 2}, order: {created_at: :desc}, limit: 5)
        @featured_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 3}, order: {created_at: :desc}, limit: 5)
    end
  end

  def request_index
    @requests = Request.includes(:user).open.order(created_at: :desc).page(params[:page])
  end

  def finance
    authenticate_user!
    @purchases = current_user.purchases.order(updated_at: :desc)
    @sales = current_user.sales.where.not(status: "denied").order(updated_at: :desc)
  end

  def liked
    @liked_gigs = Gig.find(current_user.likes.pluck(:gig_id))
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(dashboard_admins_path) : nil
  end

  def search model, includes, status
    (params[:query] == "")? query = "*" : query = params[:query]
    if params[:category_id] != "" && params[:location] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id], location: params[:location]}, page: params[:page], per_page: 20
    elsif params[:category_id] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id]}, page: params[:page], per_page: 20
    elsif  params[:location] != ""
      model.search query,includes: includes, where: {status: status, location: params[:location]}, page: params[:page], per_page: 20
    else
      model.search query,includes: includes, where: {status: status}, page: params[:page], per_page: 20
    end
  end

  def pending_review
    if params[:review]
      #get the most recent pending review
      @review = Review.search("*", where: { giver_id: current_user.id, status: "pending" }, order:{created_at: :desc}, limit: 1 )
      puts "X"* 500
      puts @review.results
    end
  end

end
