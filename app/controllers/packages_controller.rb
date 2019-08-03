class PackagesController < ApplicationController
  layout 'logged'
  include PackTypes
  include OpenpayHelper
  include MoneyHelper
  include BannedFunctions
  access user: :all
  before_action :redirect_if_user_banned, only: [:hire]
  before_action :set_gig_and_packages, only: [ :create, :update_packages]
  before_action :check_gig_ownership, only: [ :create, :update_packages]
  before_action :set_gig_by_package, only: [:hire]
  before_action :check_no_ownership, only: [:hire]
  before_action :check_quantity, only: [:hire]
  before_action :validate_create, only: [:create]
  before_action :validate_update, only: [:update_packages]

  def hire
    @openpay_id = current_user.openpay_id
    @order = Order.new
    @user_cards = get_openpay_resource("card", @openpay_id)
    @billing_profiles = current_user.billing_profiles.enabled
    @base_price = (params[:quantity].present?)? @package.price*params[:quantity].to_i : @package.price
    @price = calc_hire_view(@base_price)
  end

  def create
    @gig.with_lock do
      if @gig.gig_packages.count == 0 && params[:packages].count == 3 #just if there are no packages and packages sent to server are 3
        create_the_packages
        fp = @gig.gig_packages[0] #fp = first package
        @gig.published! if fp.present? && fp.name != "" && fp.description != "" && fp.price != nil && ((fp.max_amount.present?)? fp.price >= 1 : fp.price >= 100) && current_user.active?
      end
      end_form
    end
  end

  def update_packages
    @gig.with_lock do
      if @gig.gig_packages.count == 3 #just if the packages exist
        @gig.gig_packages.each do |record|
          pack = pack_params(record.slug)
          # pack = package_params(pack)
          if record.update(pack)
            @success = true
          else
            @success = false
            @active_orders = true
            @error = "Un paquete no ha podido actualizarse debido a que tienes órdenes pendientes, activas o disputadas"
            break
          end
        end
      elsif @gig.gig_packages.count == 0 && params[:packages].count == 3
        create_the_packages #when user creates gig and leaves empy packages, then in update it has to create them
      end
    end
    end_form
  end

  private
  # used in create
  def package_params(my_params)
    my_params.permit(:name, :description, :price, :max_amount, :min_amount, :unit_type )
  end
  # used in update
  def pack_params(slug)
    pack_params = params[:packages].require(slug).permit(:name,
                                :description,
                                :price,
                                :max_amount,
                                :min_amount,
                                :unit_type
                              )
    pack_params[:max_amount] ||= "" #if max amount is not sent, maybe user changed from units to service, so add it for deletion if necessary
    pack_params[:unit_type] ||= ""
    pack_params[:min_amount] ||= ""
    pack_params
  end

  def end_form
    respond_to do |format|
      format.js {
        render "end_form"
       }
    end
  end

  def create_the_packages
    params[:packages].each_with_index do |pack, pack_type|
        pack = package_params(pack)
        pack[:pack_type] = pack_type
        pack[:gig_id] = @gig.id
        @pack = Package.new(pack)
        @success = @pack.save
    end
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
    if current_user == @package.gig.user
      flash[:notice] = "No puedes contratarte a ti mismo"
      redirect_to( the_gig_path(@package.gig) )
    end
  end

  def check_quantity
    if (params[:quantity].present? && (@package.min_amount.nil? || @package.max_amount.nil? || params[:quantity].to_i < @package.min_amount || @package.max_amount < params[:quantity].to_i ) ) || (!params[:quantity].present? && (@package.max_amount.present? || @package.min_amount.present?))
      #if quantity is present and if ( package doesnt support quantity or the value is not in admitted range )
      #if quantity isnt present and package supports unit_quantity
      flash[:error] = "Solicitud de contratación inválida"
      redirect_to( the_gig_path(@package.gig))
    end
  end

  def validate_create
    params[:packages].each do |pack|
      @pack = Package.new( package_params(pack).merge(:gig_required => false) )
      # if pack[:max_amount].present?
      #   @error = "La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN" if (pack[:price].to_f * pack[:max_amount].to_f > 10000)
      #   @error = "No puedes vender menos de 1 unidad" if (pack[:min_amount].to_f < 1 )
      #   @error = "El mínimo de unidades debe ser menor al mayor número de unidades" if (pack[:min_amount].to_f >= pack[:max_amount].to_f )
      #   @error = "El precio es demasiado bajo o no se proporcionó" if (pack[:price] != "" && pack[:price].to_f < 1)
      #   @error = "No puedes ganar arriba de de 5000 MXN por unidad" if (pack[:price] != "" && pack[:price].to_f > 5000)
      # else
      #   @error = "El precio es demasiado bajo o no se proporcionó" if (pack[:price] != "" && pack[:price].to_f < 100)
      #   @error = "No puedes ganar arriba de de 10,000 MXN" if (pack[:price] != "" && pack[:price].to_f > 10000)
      # end
      # @error = "Sólo se admiten como máximo 1000 caracteres en la descripción" if pack[:description].length > 1000
      # @error = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if is_filled(@pack) && ! @pack.valid? #the package is filled and isnt valid
        render "error"
        break
      end
    end
  end
  def validate_update
    @gig.gig_packages.each do |record|
      @pack = Package.new( pack_params(record.slug).merge(:gig_required => false) )
      # if pack[:max_amount].present?
      #   @error = "La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN" if (pack[:price].to_f * pack[:max_amount].to_i > 10000)
      #   @error = "No puedes vender menos de 1 unidad" if (pack[:min_amount].to_i < 1 )
      #   @error = "El mínimo de unidades debe ser menor al mayor número de unidades" if (pack[:min_amount].to_i >= pack[:max_amount].to_i )
      #   @error = "El precio es demasiado bajo o no se proporcionó" if (pack[:price] != "" && pack[:price].to_f < 1)
      #   @error = "No puedes ganar arriba de de 5000 MXN por unidad" if (pack[:price] != "" && pack[:price].to_f > 5000)
      # else
      #   @error = "El precio es demasiado bajo o no se proporcionó" if ( pack[:price] != "" && pack[:price].to_f < 100)
      #   @error = "No puedes ganar arriba de de 10,000 MXN" if (pack[:price] != "" && pack[:price].to_f > 10000)
      # end
      # @error = "Sólo se admiten como máximo 1000 caracteres en la descripción" if pack[:description].length > 1000
      # @error = "El nombre contiene más de 100 caracteres" if pack[:name].length > 100
      if is_filled(@pack) && ! @pack.valid? #the package is filled and isnt valid
        render "error"
        break
      end
    end
  end

  def is_filled pack
    if pack[:name].present? || pack[:description].present? || pack[:price].present?
      return true
    else
      return false
    end
  end

end
