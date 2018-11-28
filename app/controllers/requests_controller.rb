class RequestsController < ApplicationController
  layout 'logged'
  include SanitizeParams
  include RequestsHelper
  before_action :authenticate_user!, except: :show
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  access all: [:show], user: :all
  before_action :check_request_ownership, only:[:edit, :update, :destroy]
  before_action :validate_options_for_budget, only: [:create, :update]

  def my_requests
    if params[:current]
      instance_variable_set("@"+params[:current],Request.search("*",includes: [:user], where: {status: params[:current] , user_id: current_user.id}, order: {created_at: :desc}, page: params[:open_page], per_page: 20 ))
    else
      @open = Request.search "*",includes: [:user], where: {status: "open", user_id: current_user.id}, order: {created_at: :desc}, page: params[:open_page], per_page: 20
      @in_progress = Request.search "*",includes: [:user], where: {status: "in_progress", user_id: current_user.id}, order: {created_at: :desc}, page: params[:in_progress_page], per_page: 20
      @completed = Request.search "*",includes: [:user], where: {status: "completed", user_id: current_user.id}, order: {created_at: :desc}, page: params[:completed_page], per_page: 20
      @closed = Request.search "*",includes: [:user], where: {status: "closed", user_id: current_user.id}, order: {created_at: :desc}, page: params[:closed_page], per_page: 20
    end
  end
  # GET /requests/1
  def show
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
      redirect_to request_path(@request), notice: 'Request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to request_path(@request), notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to my_request_path, notice: 'Request was successfully destroyed.'
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
end
