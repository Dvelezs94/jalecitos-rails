class RepliesController < ApplicationController
  before_action :authenticate_user!
  access user: :all, admin: :all

  # POST /replies
  def create
    @reply = Reply.new(reply_params)

    if @reply.save
      redirect_to order_dispute_path(@reply.dispute.order.uuid, @reply.dispute), notice: 'Tu replica fue creada.'
    else
      redirect_to order_dispute_path(@reply.dispute.order.uuid, @reply.dispute), error: 'Tu replica no pudo ser creada.'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def reply_params
      @dispute = Dispute.find(params[:dispute_id])
      reply_params = params.permit(:message)
      reply_params[:user] = current_user
      reply_params[:dispute] = @dispute
      reply_params
    end
end
