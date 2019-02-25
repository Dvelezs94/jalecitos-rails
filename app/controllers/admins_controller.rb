class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all
  include OpenpayHelper
  before_action :set_vars
  before_action only: [:create_openpay_user, :openpay_dashboard] do
    init_openpay("customer")
  end

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

  def tickets
    @tickets = Ticket.order(status: :asc).page(params[:ticket_page]).per(25)
  end

  def openpay_dashboard
    @balance = @customer.get(ENV.fetch("OPENPAY_PREDISPERSION_CLIENT"))["balance"] if ENV.fetch("OPENPAY_PREDISPERSION_CLIENT") != ""
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
    redirect_to root_path
  end

  private
  def set_vars
    @pending_verifications = Verification.pending.count
    @pending_bans = Ban.pending.count
    @pending_disputes = Dispute.waiting_for_support.count
    @open_tickets = Ticket.in_progress.count
  end
end
