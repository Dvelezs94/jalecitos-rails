class RequestsController < ApplicationController
  include SetLayout
  include GetRequest
  before_action :authenticate_user!, except: :show
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  access all: [:show], user: :all
  before_action :check_request_ban, only: [:show]
  before_action :check_request_ownership, only:[:edit, :update, :destroy]
  before_action :verify_no_employee, only: [:edit, :update, :destroy]
  layout :set_layout


  # GET /requests/1
  def show
    if params[:page]
      get_other_offers
    else
      report_options
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
    @request = Request.new( request_params )
    if @request.save
      redirect_to request_path(@request), notice: 'Tu pedido fue creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to request_path(@request), notice: 'El pedido ha sido actualizado.'
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
                                  :image,
                                  :city_id,
                                  :category_id,
                                  :budget,
                                  :tag_list,
                                  :profession
                                )
      request_params = set_owner(request_params)
    end

    def set_owner parameters
      parameters[:user_id] = current_user.id
      parameters
    end

    def check_request_ownership
      if current_user.id != @request.user_id
        redirect_to root_path
      end
    end

    def check_request_ban
     flash[:error]='Este Pedido está baneado' if @request.banned?
    end

    def report_options
      @report_options = ["Uso de palabras ofensivas", "Contenido Sexual", "Violencia", "Spam", "Engaño o fraude", "Otro"]
    end

    #check if there is no empoyee yet, so we can edit or delete the gig
    def verify_no_employee
      (@request.employee) ? redirect_to(request_path(@request), notice: 'El pedido ya no puede ser borrado o editado') : true
    end
end
