class PackagesController < ApplicationController
  before_action :set_gig, only: [:new, :create, :edit, :update]
  before_action :check_package_ownership, only: [:new, :create, :edit, :update]
  access user: :all

  def new
    @types =['Básico', 'Estándar' ,'Premium']
    @package =[]
    3.times do
      @package << Package.new
    end
  end

  def create
    if params[:packages].count == 3
      params[:packages].each_with_index do |pack, pack_type|
          pack = package_params(pack)
          pack[:pack_type] = pack_type
          pack[:gig_id] = gig_param
          @pack = Package.new(pack)
          @pack.save
      end
    end

    redirect_to gigs_path, notice: 'Tu Gig se ha creado exitosamente'

  end

  def edit
  end

  def update
  end

  private
    # Only allow a trusted parameter "white list" through.
    def gig_param
      gig_param = params.require(:gig_id)
    end
    def package_params(my_params)
      my_params.permit(:name, :description, :price )
    end

  def set_gig
    @gig = Gig.find(params[:gig_id])
  end

  def check_package_ownership
    if ! current_user || current_user.id != @gig.user_id
      redirect_to root_path
    end
  end
end
