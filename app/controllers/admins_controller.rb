class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all
  include ActionView::Helpers::NumberHelper
  before_action :set_vars
  before_action :set_balance, only: [:openpay_dashboard, :predispersion_fee]

  def index_dashboard
    @gigs = Gig.includes(:user).order(updated_at: :desc).page(params[:gig]).per(25)
    set_paginator
  end

  def categories
    @categories =  Category.order(:name)
  end

  def users
    @users =  User.where.not(slug: nil).order(created_at: :desc).page(params[:user]).per(25)
    @malformed_users =  User.where(slug: nil)
    set_paginator
  end

  def reports
    @reports = Report.open.order(created_at: :asc).page(params[:report]).per(25)
    set_paginator
  end

  def bans
    @bans = Ban.banned.where.not(baneable_type: "Request").order(status: :asc).page(params[:ban]).per(25)
    set_paginator
  end

  def verifications
    @verifications = Verification.order(status: :asc).page(params[:verification]).per(25)
    set_paginator
  end

  def show_verification
      @verification = Verification.find(params[:id])
  end


  def marketing_notifications
    @marketing_notifications = MarketingNotification.order(scheduled_at: :desc).page(params[:marketing_notification]).per(25)
    @marketing_notification = MarketingNotification.new
    set_paginator
  end


  private
  def set_vars
    if request.format.html?
      @pending_verifications = Verification.all.pending.length
      @open_reports = Report.open.length
      @banned_bans = Ban.banned.where.not(baneable_type: "Request").length
      @pending_disputes = Dispute.waiting_for_support.length
      @open_tickets = Ticket.in_progress.where(turn: "waiting_for_support").length
      @user_count = User.all.length
      @pending_payment_orders_count = Order.payment_verification_pending.completed.length
      @gigs_count = Gig.all.length
    end
  end

  def set_paginator
    render "pagination" if request.format.js?
  end

  def set_balance
    @balance = (@customer.get(ENV.fetch("OPENPAY_PREDISPERSION_CLIENT"))["balance"]) if ENV.fetch("OPENPAY_PREDISPERSION_CLIENT") != ""
    @balance95 = (@balance * 0.95).round(2)
  end
end
