class RequestsController < ApplicationController
  layout 'request'
  include SanitizeParams
  before_action :authenticate_user!, except: :show
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  access all: [:show], user: :all
  before_action :check_request_ownership, only:[:edit, :update, :destroy]

  def my_requests
    @requests = Request.includes(:user).friendly.where(user_id: current_user.id).order(:id).order(created_at: :desc)
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
      redirect_to user_request_path(@request.user.slug, @request), notice: 'Request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to user_request_path(@request.user.slug, @request), notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to my_user_requests_path(current_user.slug), notice: 'Request was successfully destroyed.'
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
end
