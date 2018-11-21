class DisputesController < ApplicationController
  before_action :set_dispute, only: [:show, :edit, :update, :destroy]
  access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all
  layout 'logged'
  access user: :all

  # GET /disputes
  def index
    @disputes = current_user.disputes
  end

  # GET /disputes/1
  def show
  end

  # GET /disputes/new
  def new
    @dispute = Dispute.new
  end

  # POST /disputes
  def create
    @dispute = Dispute.new(dispute_params)

    if @dispute.save
      @dispute.order.disputed!
      redirect_to @dispute, notice: 'Dispute was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispute
      @dispute = Dispute.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dispute_params
      @disputed_order = Order.find_by_uuid(params[:order_id])
      dispute_params = params.require(:dispute).permit(:description)
      dispute_params[:order] = @disputed_order
      dispute_params
    end
end
