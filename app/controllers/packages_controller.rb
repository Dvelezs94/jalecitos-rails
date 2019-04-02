class PackagesController < ApplicationController
  layout 'logged'
  include PackTypes
  include OpenpayHelper
  include MoneyHelper
  before_action :set_gig_and_packages, only: [ :create, :update_packages]
  before_action :check_gig_ownership, only: [ :create, :update_packages]
  before_action :set_gig_by_package, only: [:hire]
  before_action :check_no_ownership, only: [:hire]
  before_action :validate_create, only: [:create]
  before_action :validate_update, only: [:update_packages]
  access user: :all

  def hire
    @openpay_id = current_user.openpay_id
    @order = Order.new
    @user_cards = get_openpay_resource("card", @openpay_id)
    @billing_profiles = current_user.billing_profiles.enabled
    @price = calc_hire_view(@package.price)
  end

  def create
    @gig.with_lock do
      if @gig.gig_packages.count == 0 && params[:packages].count == 3 #just if there are no packages and packages sent to server are 3
        params[:packages].each_with_index do |pack, pack_type|
            pack = package_params(pack)
            pack[:pack_type] = pack_type
            pack[:gig_id] = @gig.id
            @pack = Package.new(pack)
            @success = @pack.save
        end
        @gig.published! if @gig.gig_packages[0].present? && @gig.gig_packages[0].name != "" && @gig.gig_packages[0].description != "" && @gig.gig_packages[0].price != nil && @gig.gig_packages[0].price >= 100
      end
      respond_to do |format|
        format.js {
          render "end_form"
         }
      end
    end
  end

  def update_packages
    @gig.with_lock do
      if @gig.gig_packages.count == 3 #just if the packages exist
        @gig.gig_packages.each do |record|
          pack = params[:packages]["#{record.slug}"]
          pack = package_params(pack)
          if record.update(pack)
            @success = true
          else
            @success = false
            @active_orders = true
            break
          end
        end
        respond_to do |format|
          format.js {
            render "end_form"
           }
        end
      end
    end
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
    @gig = Gig.includes(:gig_packages).find(params[:gig_id])
  end


  def check_gig_ownership
    head(:no_content) if (current_user.nil? || current_user.id != @gig.user_id)
  end

  def check_no_ownership
    redirect_to( gig_path(@package.gig), notice: "No puedes contratarte a ti mismo." ) if (current_user == @package.gig.user )
  end

  def validate_create
    params[:packages].each do |pack|
      @error = "El precio es demasiado bajo o no se proporcionó" if (pack[:price].to_f < 100 && pack[:price] != "")
      @error = "No puedes ganar arriba de de 9,000 MXN" if (pack[:price].to_f > 10000)
      @error = "Sólo se admiten como máximo 1000 caracteres en la descripción" if pack[:description].length > 1000
      @error = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if @error
        render "error"
        break
      end
    end
  end
  def validate_update
    @gig.gig_packages.each do |record|
      pack = params[:packages]["#{record.slug}"]
      @error = "El precio es demasiado bajo o no se proporcionó" if (pack[:price].to_f < 100 && pack[:price] != "")
      @error = "No puedes ganar arriba de de 9,000 MXN" if (pack[:price].to_f > 10000)
      @error = "Sólo se admiten como máximo 1000 caracteres en la descripción" if pack[:description].length > 1000
      @error = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if @error
        render "error"
        break
      end
    end
  end
end
