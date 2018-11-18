class PackagesController < ApplicationController
  layout 'logged'
  include SanitizeParams
  include PackTypes
  include DescriptionRestrictions
  include OpenpayHelper
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
  @openpay_id = current_user.openpay_id
  @order = Order.new
  @user_cards = get_openpay_resource("card", @openpay_id)
end

  def new
    prepare_packages
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
      @gig.published! if @gig.gig_packages[0].present? && @gig.gig_packages[0].name != "" && @gig.gig_packages[0].description != "" && @gig.gig_packages[0].price != nil && @gig.gig_packages[0].price > 100
    end
    redirect_to user_gig_path(params[:user_id], @gig), notice: 'Tu Gig se ha publicado exitosamente'
  end

  def edit_packages
    define_pack_names
  end


  def update_packages
    @gig.gig_packages.each do |record|
      pack = params[:packages]["#{record.slug}"]
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

    def prepare_packages
      define_pack_names
      @new_packages =[]
      3.times do
        @new_packages << Package.new
      end
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
      real_char = decodeHTMLEntities(pack[:description])
      noHtml = pack[:description].gsub(/<[^>]*>/, "")
      noHtml_real_char = decodeHTMLEntities(noHtml)
      flash.now[:error] = "El precio es demasiado bajo o no se proporcionó" if (pack[:price].to_f < 100 && pack[:price] != "")
      flash.now[:error] = "Sólo se admiten como máximo 1000 caracteres" if noHtml_real_char.length > 1000
      flash.now[:error] = "La descriptión contiene demasiados efectos de texto" if real_char.length > 2000
      flash.now[:error] = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if flash.now[:error]
        prepare_packages
        render :new
        break
      end
    end
  end
  def validate_update
    @gig.gig_packages.each do |record|
      pack = params[:packages]["#{record.slug}"]
      real_char = decodeHTMLEntities(pack[:description])
      noHtml = pack[:description].gsub(/<[^>]*>/, "")
      noHtml_real_char = decodeHTMLEntities(noHtml)
      flash.now[:error] = "El precio es demasiado bajo o no se proporcionó" if (pack[:price].to_f < 100 && pack[:price] != "")
      flash.now[:error] = "Sólo se admiten como máximo 1000 caracteres" if noHtml_real_char.length > 1000
      flash.now[:error] = "La descriptión contiene demasiados efectos de texto" if real_char.length > 2000
      flash.now[:error] = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if flash.now[:error]
        define_pack_names
        render :edit_packages
        break
      end
    end
  end
end
