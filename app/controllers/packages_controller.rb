class PackagesController < ApplicationController
  layout 'gig'
  include SanitizeParams
  before_action :set_gig_and_packages, only: [:new, :create, :edit_packages, :update_packages]
  before_action :check_gig_ownership, only: [:new, :create, :edit_packages, :update_packages]
  before_action :create_redirect, only: [:new, :create]
  before_action :update_redirect, only: [:edit_packages, :update_packages]
  access user: :all

  def new
    define_pack_names
    @new_packages =[]
    3.times do
      @new_packages << Package.new
    end
  end

  def create
    if params[:packages].count == 3
      params[:packages].each_with_index do |pack, pack_type|
          pack = sanitized_params( package_params(pack) )
          pack[:pack_type] = pack_type
          pack[:gig_id] = @gig.id
          @pack = Package.new(pack)
          @pack.save
      end
    end
    redirect_to user_gig_path(params[:user_id], @gig), notice: 'Tu Gig se ha creado exitosamente'
  end

  def edit_packages
    define_pack_names
  end


  def update_packages
    @gig.packages.each do |record|
      pack = params[:packages]["#{record.id}"]
      pack = sanitized_params( package_params(pack) )
      record.update(pack)
    end
    redirect_to user_gig_path(params[:user_id], @gig), notice: 'Tu Gig se ha actualizado exitosamente'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def package_params(my_params)
      my_params.permit(:name, :description, :price )
    end

  def set_gig_and_packages
    @gig = Gig.includes(:packages).friendly.find(params[:gig_id])
  end

  def create_redirect
    (@gig.packages.any?) ? redirect_to( edit_user_gig_packages_path(params[:user_id],@gig) ) : nil
  end

  def update_redirect
    (@gig.packages.none?) ? redirect_to( new_user_gig_package_path(params[:user_id], @gig) ) : nil
  end

  def define_pack_names
    @types =['Básico', 'Estándar' ,'Premium']
  end


  def check_gig_ownership
    (current_user.nil? || current_user.id != @gig.user_id) ? redirect_to(root_path) : nil
  end
end
