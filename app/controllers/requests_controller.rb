class RequestsController < ApplicationController
  layout 'logged'
  include SanitizeParams
  include RequestsHelper
  before_action :authenticate_user!, except: :show
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  access all: [:show], user: :all
  before_action :check_request_ban, only: [:show]
  before_action :check_request_ownership, only:[:edit, :update, :destroy]
  before_action :validate_options_for_budget, only: [:create, :update]
  before_action :verify_no_employee, only: [:edit, :update, :destroy]

  def my_requests
      @open = Request.search "*",includes: [:user], where: {status: "open", user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:open_page], per_page: 20
      @in_progress = Request.search "*",includes: [:user], where: {status: "in_progress", user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:in_progress_page], per_page: 20
      @completed = Request.search "*",includes: [:user], where: {status: "completed", user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:completed_page], per_page: 20
      @closed = Request.search "*",includes: [:user], where: {status: "closed", user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:closed_page], per_page: 20
      @banned = Request.search "*",includes: [:user], where: {status: "banned", user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:banned_page], per_page: 20
  end
  # GET /requests/1
  def show
    report_options
    @hires_open = (@request.employee.nil?) ? true : false
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
    @request = Request.new( sanitized_params(request_params) )
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
      @request = Request.includes(:offers).friendly.find(params[:id])
    end

    def request_params
      request_params = params.require(:request).permit(:name,
                                  :description,
                                  :image,
                                  :location,
                                  :category_id,
                                  :budget,
                                  :tag_list
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

    def validate_options_for_budget
      if ! options_for_budget.include?([request_params[:budget]])
        flash[:error] = "No ingresaste una opcion valida"
        redirect_to root_path
      end
    end

    def check_request_ban
     (@request.banned?) ? flash[:error]='Este Pedido está baneado' : nil
    end

    def report_options
      @report_options = ["Uso de palabras ofensivas", "Contenido Sexual", "Violencia", "Spam", "Engaño o fraude", "Otro"]
    end

    #check if there is no empoyee yet, so we can edit or delete the gig
    def verify_no_employee
      (@request.employee) ? redirect_to(request_path(@request), notice: 'El pedido ya no puede ser borrado o editado') : true
    end
end
