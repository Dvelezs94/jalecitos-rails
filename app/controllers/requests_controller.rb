class RequestsController < ApplicationController
  include SetLayout
  include GetRequest
  before_action :authenticate_user!, except: :show
  before_action :set_request, only: [:show, :destroy]
  before_action :set_req_update, only: [:edit, :update]
  before_action :set_req_create, only: [:create]
  access all: [:show], user: :all
  before_action :check_request_ban, only: [:show]
  before_action :check_request_ownership, only:[:edit, :update, :destroy, :create]
  before_action :verify_no_employee, only: [:edit, :update, :destroy]
  layout :set_layout


  # GET /requests/1
  def show
    if params[:page]
      get_other_offers
    else
      @hires_open = (@request.employee.nil?) ? true : false
      if @request.offers_count > 0 #search offers is there some
        get_other_offers
       if @other_offers.length < @request.offers_count #that means the user has an offer
         @my_offer = @request.offers.includes(user: :score).find_by_user_id(current_user.id)
       end
      end
    end
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  def create
    if params[:req_id].present? #editing in creation
      @success = @request.update(request_params)
      if !@success
        render :new
      end
    else #create
      @success = @request.save
      if !@success
        render :new
      end
    end
    respond_to do |format|
      format.js {
        render "update_name"
       }
    end

  end

  # PATCH/PUT /requests/1
  def update
    @success = @request.update(request_params)
    if @success
      # @package = Package.find_by_gig_id(@gig)
      respond_to do |format|
        format.js {
          render "update_name"
         }
      end
    else
      render :edit
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to root_path, notice: 'El pedido ha sido eliminado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      #dont include offers because the logic does it
      @request = Request.includes(:user, city: [state: :country]).friendly.find(params[:id])
    end

    def request_params
      request_params = params.require(:request).permit(:name,
                                  :description,
                                  :city_id,
                                  :category_id,
                                  :budget,
                                  :tag_list,
                                  :profession
                                ).merge(:user_id => current_user.id)
    end

    def check_request_ownership
      if current_user.id != @request.user_id
        redirect_to root_path
      end
    end

    def check_request_ban
      if @request.banned? && ! current_user.has_role?(:admin)
       flash[:error] = 'Este Pedido está bloqueado'
       redirect_to request.referrer || root_path
      end
    end

    def set_req_create
      if params[:req_id].present? #edit in creation
        @request = Request.find(params[:req_id])
      else #create
        @request = Request.new(request_params)
      end
    end

    def set_req_update
      if params[:req_id].present? #after edit name in update, slug changes
        @request = Request.find(params[:req_id])
      else #before changing name it can be finded by original name
        @request = Request.friendly.find(params[:id])
      end
    end

    #check if there is no empoyee yet, so we can edit or delete the gig
    def verify_no_employee
      (@request.employee) ? redirect_to(request_path(@request), notice: 'El pedido ya no puede ser borrado o editado') : true
    end
end
