class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all
  before_action :set_vars

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
    @bans = Ban.order(status: :asc).page(params[:ban_page]).per(25)
  end

  def verifications
    @verifications = Verification.order(status: :asc).page(params[:ban_page]).per(25)
  end

  private
  def set_vars
    @pending_verifications = Verification.pending.count
    @pending_bans = Ban.pending.count
    @pending_disputes = Dispute.waiting_for_support.count
  end
end
