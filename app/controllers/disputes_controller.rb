class DisputesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dispute, only: [:show]
  before_action :check_dispute_ownership, only: :show
  layout 'logged'
  access user: :all, admin: :all

  # GET /disputes/1
  def show
    @replies = @dispute.replies.order(created_at: :desc)
  end

  # GET /disputes/new
  def new
    @dispute = Dispute.new
  end

  # POST /disputes
  def create
    @dispute = Dispute.new(dispute_params)

    if @dispute.order.in_progress?
      if @dispute.save
        @dispute.order.disputed!
        if current_user == @dispute.order.employee
          create_notification(@dispute.order.employee, @dispute.order.employer, "Abrio una disputa", @dispute)
        else
          create_notification(@dispute.order.employer, @dispute.order.employee, "Abrio una disputa", @dispute)
        end
        redirect_to order_dispute_path(@dispute.order.uuid, @dispute), notice: 'La disputa fue creada exitosamente.'
      else
        render :new
      end
    else
      @order = Order.find_by_uuid(params[:order_id])
      redirect_to order_dispute_path( @order.uuid, @order.dispute), notice: 'La disputa ya existe.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispute
      @dispute = Dispute.find(params[:id])
    end

    def check_dispute_ownership
      if ! (current_user == @dispute.order.employer || current_user == @dispute.order.employee || current_user.has_roles?(:admin))
          redirect_to root_path, error: "No puedes acceder aquí."
      end
    end

    # Only allow a trusted parameter "white list" through.
    def dispute_params
      @disputed_order = Order.find_by_uuid(params[:order_id])
      dispute_params = params.require(:dispute).permit(:description, :image)
      dispute_params[:order] = @disputed_order
      dispute_params
    end
end
