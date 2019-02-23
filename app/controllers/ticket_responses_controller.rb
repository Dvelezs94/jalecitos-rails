class TicketResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user

  def create
    @ticket_response = TicketResponse.new(ticket_response_params)
    @ticket_response.user = current_user
    if @ticket_response.save
      redirect_to ticket_path(@ticket_response.ticket)
    else
      redirect_to ticket_path(@ticket_response.ticket), alert: 'Hubo un error al crear la replica'
    end
  end

  private
  def ticket_response_params
      params.require(:ticket_response).permit(:message, :image, :ticket_id)
  end

  def validate_user
    if ! current_user.has_role?(:admin)
      redirect_to ticket_path(@ticket_response.ticket), alert: 'Hubo un error al crear la replica' if ! current_user.tickets.find(ticket_response_params[:ticket_id])
    end
  end
end
