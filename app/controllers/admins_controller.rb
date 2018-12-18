class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all

  def index_dashboard
    @gigs = Gig.order(updated_at: :desc).page(params[:gig_page]).per(25)
  end

  def categories
    @categories =  Category.order(:name).page(params[:category_page]).per(25)
  end

  def users
    @users =  User.order(:name).page(params[:user_page]).per(25)
  end

  def disputes
    @disputes = Dispute.order(status: :asc).page(params[:dispute_page]).per(25)
  end

  def bans
    @bans = Ban.open.order(updated_at: :desc).page(params[:ban_page]).per(25)
  end
end
