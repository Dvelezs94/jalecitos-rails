class RepliesController < ApplicationController
  before_action :authenticate_user!
  access user: :all, admin: :all

  # POST /replies
  def create
    @reply = Reply.new(reply_params)
    # Allow only the turn of the employer or employee
     if @reply.dispute.status == "waiting_for_employee" && @reply.dispute.employee == current_user
      true
     elsif @reply.dispute.status == "waiting_for_employer" && @reply.dispute.employer == current_user
      true
     elsif current_user.has_roles?(:admin)
      true
     else
       redirect_to order_dispute_path(@reply.dispute.order.uuid, @reply.dispute), error: 'Tu replica no pudo ser creada.'
       return
     end

    if @reply.save
      if current_user == @reply.dispute.employer
        @reply.dispute.waiting_for_employee!
      elsif current_user == @reply.dispute.employee
        @reply.dispute.waiting_for_support!
      elsif current_user.has_roles?(:admin)
        @reply.dispute.waiting_for_employer!
      end
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
