class DisputesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dispute, only: [:show]
  before_action :check_dispute_ownership, only: :show
  before_action :check_if_can_create_dispute, only: :new
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
    @order = @dispute.order
    @order.with_lock do
      if @order.in_progress? && @order.dispute.nil?
        if @dispute.save
          @order.disputed!
          (current_user == @order.employee)? create_notification(@order.employee, @order.employer, "abrió una disputa", @dispute) : create_notification(@order.employer, @order.employee, "abrió una disputa", @dispute)
          redirect_to order_dispute_path(@order.uuid, @dispute), notice: 'La disputa fue creada exitosamente.'
        else
          render :new
        end
      elsif @order.dispute.present? #dispute already exist
        redirect_to(order_dispute_path( @order.uuid, @order.dispute), notice: 'La disputa ya existe')
      else #order isnt in progress
        flash[:notice] = "El estado de la orden no permite crear una disputa"
        redirect_to finance_path(:table => (@order.employee_id == current_user.id)? "sales" : "purchases" )
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispute
      @dispute = Dispute.find(params[:id])
    end

    # def find_order_by_uuid uuid
    #   return Order.find_by_uuid(uuid)
    # end

    def check_dispute_ownership
      if ! (current_user == @dispute.order.employer || current_user == @dispute.order.employee || current_user.has_roles?(:admin))
          redirect_to root_path, error: "No puedes acceder aquí."
      end
    end

    # Only allow a trusted parameter "white list" through.
    def dispute_params
      dispute_params = params.require(:dispute).permit(:description, {images: []}).merge(order: Order.find_by_uuid(params[:order_id]))
    end

    def check_if_can_create_dispute
      @order = Order.find_by_uuid(params[:order_id])
      if @order.dispute.present?
        redirect_to(order_dispute_path( @order.uuid, @order.dispute), notice: 'La disputa ya existe')
      elsif ! @order.in_progress?
        flash[:notice] = "El estado de la orden no permite crear una disputa"
        redirect_to finance_path(:table => (@order.employee_id == current_user.id)? "sales" : "purchases" )
      end
    end
end
