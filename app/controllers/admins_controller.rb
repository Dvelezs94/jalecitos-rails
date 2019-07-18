class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all
  include OpenpayHelper
  include ActionView::Helpers::NumberHelper
  before_action :set_vars
  before_action only: [:create_openpay_user, :openpay_dashboard, :predispersion_fee] do
    init_openpay("customer")
  end
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

  def orders
    @orders_count = Order.all.length
    @orders =  Order.order(created_at: :desc).page(params[:order]).per(25)
    set_paginator
  end

  def disputes
    @disputes = Dispute.order(status: :asc).page(params[:dispute]).per(25)
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

  def ally_codes
    @ally_codes = AllyCode.order(created_at: :desc).page(params[:ally_code]).per(25)
    @ally_code = AllyCode.new
    set_paginator
  end

  def show_verification
      @verification = Verification.find(params[:id])
  end

  def tickets
    @tickets = Ticket.order(status: :asc).page(params[:ticket]).per(25)
    set_paginator
  end

  def marketing_notifications
    @marketing_notifications = MarketingNotification.order(scheduled_at: :desc).page(params[:marketing_notification]).per(25)
    @marketing_notification = MarketingNotification.new
    set_paginator
  end

  def openpay_dashboard
    @balance ||= "cuenta predispersion no seteada"
  end

  def create_openpay_user
    request_hash={
      "name" => params[:name],
      "last_name" => nil,
      "email" => params[:email],
      "requires_account" => true
    }

    begin
      response_hash = @customer.create(request_hash.to_hash)
      flash[:success] = "Usuario creado, ID: #{response_hash['id']}"
    rescue OpenpayTransactionException => e
      flash[:error] = "#{self.alias} issue: #{e.description}, so the user could not be created on openpay"
    end
    redirect_to openpay_dashboard_admins_path
  end

  def charge_openpay_user
    fee = init_openpay("fee")
    request_client_hash={"customer_id" => params[:openpay_id],
                   "amount" => params[:amount],
                   "description" => params[:description]
                  }
    begin
      fee.create(request_client_hash)
      flash[:success] = "El saldo ha sido cobrado por la cantidad de #{number_to_currency(params[:amount].to_f)}"
    rescue OpenpayTransactionException => e
      flash[:error] = "Fallo al realizar el cargo: #{e.description}"
     end
     redirect_to openpay_dashboard_admins_path
  end

  # deposit predispersion balance to our openpay account, so we can move it later to dispersion
  def predispersion_fee
    fee = init_openpay("fee")
    request_predispersion_hash={"customer_id" => ENV.fetch("OPENPAY_PREDISPERSION_CLIENT"),
                   "amount" => @balance95,
                   "description" => "Retiro de cuenta predispersion"
                  }
    begin
      fee.create(request_predispersion_hash)
      flash[:success] = "El saldo predispersion ha sido depositado a la cuenta raiz por la cantidad de #{@balance95} (95%)"
    rescue OpenpayTransactionException => e
      flash[:error] = "Fallo al realizar el deposito: #{e}"
     end
     redirect_to openpay_dashboard_admins_path
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
