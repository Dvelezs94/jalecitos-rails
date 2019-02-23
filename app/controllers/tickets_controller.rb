class TicketsController < ApplicationController
  include SanitizeParams
  layout 'logged'
  before_action :authenticate_user!
  before_action :set_ticket, only: :show
  before_action :validate_user, only: [:show]

  def index
    @tickets = Ticket.where(user: current_user)
  end

  def new
    @ticket = Ticket.new
  end

  def show
    @ticket_responses = @ticket.ticket_responses.order(created_at: :asc)
  end

  def create
    @ticket = Ticket.new( sanitized_params(ticket_params) )
    @ticket.user = current_user
    if @ticket.save
      redirect_to ticket_path(@ticket), notice: 'Tu caso ha sido creado y seras notificado en cuanto lo revisemos.'
    else
      render :new
    end
  end

  private
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def ticket_params
      params.require(:ticket).permit(:title, :description, :priority, :image)
  end

  def validate_user
    if ! current_user.has_role?(:admin)
      render :new if current_user != @ticket.user
    end
  end
end
