class GigsController < ApplicationController
  layout 'gig'
  before_action :set_gig, only: [:show, :edit, :update, :destroy, :toggle_status, :ban_gig]
  before_action :check_gig_ownership, only:[:edit, :update, :destroy]
  before_action :check_status, only:[:update]
  access user: {except: [:ban_gig]}, admin: [:ban_gig]

  # GET /gigs
  def index
    @gigs = Gig.where(user_id: current_user.id)
  end

  # GET /gigs/1
  def show
  end

  # GET /gigs/new
  def new
    @gig = Gig.new
  end

  # GET /gigs/1/edit
  def edit
  end

  # POST /gigs
  def create
    @gig = Gig.new(params_with_user)

    if @gig.save
      redirect_to @gig, notice: 'Gig was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /gigs/1
  def update
    if @gig.update(gig_params)
      redirect_to @gig, notice: 'Gig was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /gigs/1
  def destroy
    @gig.destroy
    redirect_to gigs_url, notice: 'Gig was successfully destroyed.'
  end

  def toggle_status
    if @gig.banned?
      redirect_to gigs_path, notice: 'This Gig is banned'
    end
    if @gig.draft?
        @gig.published!
    else
         @gig.draft!
   end
   redirect_to gigs_path, notice: "Gig status has been updated"
  end

  def ban_gig
    if @gig.published? || @gig.draft?
      @gig.banned!
    else
      @gig.draft!
    end
    redirect_to root_path, notice: "Gig status has been updated"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def gig_params
      params.require(:gig).permit(:name,
                                  :description,
                                  :image,
                                  :location,
                                  :user_id,
                                  :category_id,
                                  :tag_id,
                                  :status
                                )
    end

    def params_with_user
      params_with_user = gig_params
      params_with_user['user_id'] = current_user.id
      params_with_user
    end

    def check_gig_ownership
      if current_user.id != @gig.user_id
        redirect_to root_path
      end
    end
    def check_status
      if @gig.banned?
        redirect_to gigs_path, notice: 'This Gig is banned'
      end
    end

end
