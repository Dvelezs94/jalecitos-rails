class PackagesController < ApplicationController
  layout 'logged'
  include SanitizeParams
  include PackTypes
  before_action :set_gig_and_packages, only: [:new, :create, :edit_packages, :update_packages]
  before_action :check_gig_ownership, only: [:new, :create, :edit_packages, :update_packages]
  before_action :create_redirect, only: [:new, :create]
  before_action :set_gig_by_package, only: [:hire]
  before_action :check_no_ownership, only: [:hire]
  before_action :update_redirect, only: [:edit_packages, :update_packages]
  before_action :validate_create, only: [:create]
  before_action :validate_update, only: [:update_packages]
  access user: :all

def hire
end

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
    @gig.gig_packages.each do |record|
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

  def set_gig_by_package
    @package = Package.includes(gig: :user).friendly.find(params[:id])
  end

  def set_gig_and_packages
    @gig = Gig.includes(:gig_packages).friendly.find(params[:gig_id])
  end

  def create_redirect
    (@gig.gig_packages.any?) ? redirect_to( edit_user_gig_packages_path(params[:user_id],@gig) ) : nil
  end

  def update_redirect
    (@gig.gig_packages.none?) ? redirect_to( new_user_gig_package_path(params[:user_id], @gig) ) : nil
  end


  def check_gig_ownership
    @gig = Gig.friendly.find(params[:gig_id])
    (current_user.nil? || current_user.id != @gig.user_id) ? redirect_to(root_path) : nil
  end

  def check_no_ownership
    (current_user.id == @package.gig.user_id )? redirect_to( user_gig_path(current_user, @package.gig), notice: "No puedes contratarte a ti mismo." ) : nil
  end

  def validate_create
    params[:packages].each do |pack|
      if pack[:name].length > 100 || pack[:description].length > 1000 || (pack[:price].to_f < 100 && pack[:price] != "")
        redirect_to(root_path, notice: "Sus paquetes no han podido guardarse, por favor, inténtelo de nuevo.")
        break
      end
    end
  end
  def validate_update
    @gig.gig_packages.each do |record|
      pack = params[:packages]["#{record.id}"]
      if pack[:name].length > 100 || pack[:description].length > 1000 || (pack[:price].to_f < 100 && pack[:price] != "")
        redirect_to(root_path, notice: "Sus paquetes no han podido guardarse, por favor, inténtelo de nuevo.")
        break
      end
    end
  end
end
