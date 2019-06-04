class User < ApplicationRecord
  attr_accessor :lat, :lon, :roles_word
  include ApplicationHelper
  #includes
  #friendly_id
  extend FriendlyId
  #Payments
  include OpenpayFunctions
  include OpenpayHelper
  #validations
  include LocationFunctions
  #inspects
  include AliasFunctions
  #tags
  include TagRestrictions
  # Avatar image
  mount_uploader :image, AvatarUploader
  #search
  searchkick language: "spanish"
  # only send these fields to elasticsearch
  def search_data
    {
      tags: tag_list.join(" "),
      city_id: city_id
    }
  end
  #Define who can do the rating, which happens to be the user
  ratyrate_rater
  #Tags
  acts_as_taggable
  #enum
  enum status: { active: 0, disabled: 1, banned: 2}

  # Create default values
  before_validation :set_defaults, on: :create
  friendly_id :alias, use: :slugged #this is after the alias is generated because if not then it will generate a number slug because alias isnt set yet
  # Validates uniqueness of id
  validates :email, :alias,  uniqueness: true
  validates_numericality_of :age, greater_than_or_equal_to: 0, less_than: 101, allow_blank: true
  validates :available, :inclusion=> { :in => ["Tiempo completo", "Medio tiempo", "Esporádico", "Fin de semana"]}, allow_blank: true
  validates_length_of :name, maximum: 100
  validates_length_of :alias, maximum: 30
  validate :maximum_amount_of_tags, :no_spaces_in_tag, :tag_length
  # validate :location_syntax
  validates_length_of :bio, maximum: 500
  validates_presence_of :alias, :slug
  validates :alias, format: { :with => /\A[a-zA-Z0-9\-\_]+\z/, message: "sólo puede contener caracteres alfanuméricos, guión y guión bajo." }
  validates :name, format: { :with => /\A[a-zA-Z\p{L}\p{M}\s]+\z/, message: "Sólo puede contener letras y espacios" }, :allow_blank => true #allow blank because on creation it doesnt have
  validates_presence_of :name, if: :name_changed?  #dont allow blank again if value is filled
  validate :check_running_orders, if: :user_disabled?, on: :update

  # Create User Score and openpay user
  after_validation :create_user_score
  after_validation :create_openpay_account

  before_create :set_location
  # update user timezone if location changed
  before_update :update_time_zone, :if => :city_id_changed?
  # update verified gigs when account is verified
  before_update :verify_gigs, :if => :verified_changed?
  before_update :set_roles
  #when user is banned, unbanned or disabled...
  before_update :enable_disable_stuff, :if => :status_changed?

  # Associations
  # User Score
  belongs_to :score, foreign_key: :score_id, class_name: "UserScore", optional: true

  belongs_to :city, optional: true
  # ally code in case it has one
  belongs_to :ally_code, optional: true
  #after_update :decrement_ally_code_times_left, :if => :ally_code_id_changed?
  before_save :decrement_ally_code_times_left, if: :will_save_change_to_ally_code_id?
  # reports
  has_many :reports
  # Ticket system
  has_many :tickets
  has_many :ticket_responses
  # Chat Relations
  has_many :messages
  # Request System
  has_many :requests
  has_many :offers
  # Gigs
  has_many :gigs
  # Payouts
  has_many :payouts
  # Notifications
  has_many :notifications, as: :recipient
  # Orders and sales
  has_many :purchases, class_name: :Order, foreign_key: :employer
  has_many :sales, class_name: :Order, foreign_key: :employee
  #Reviews (giver)
  has_many :giver, class_name: :Review, foreign_key: :giver_id
  has_many :receiver, class_name: :Review, foreign_key: :receiver_id
  #Push subscriptions reference
  has_many :push_subscriptions
  # Billing info (Invoices Profiles relation)
  has_many :billing_profiles
  # likes
  has_many :likes
  #verifications
  has_many :verifications
  #find liked gigs
  def likes?(gig)
    gig.likes.where(user: self).any?
  end
  #conversations
  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end
  #disputes
  def disputes
    Dispute.where(order_id: Order.where(employer_id: self.id)).or(Dispute.where(order_id: Order.where(employee_id: self.id)))
  end

  def unpaid_orders
    Order.where(employee: self, status: "completed", paid_at: nil)
  end

  def verify_gigs
      self.gigs.each { |gig| gig.touch }
  end

  def level_enabled?
    @ally_code = self.ally_code
    if @ally_code.present?
      if @ally_code.level_enabled
        true
      else
        # 0 stands for ally level, which in this case is disabled
        false
      end
    else
      true
    end
  end
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:admin, :support, :employer, :employee], multiple: true)                                      ##
  ############################################################################################
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :secure_validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  #this is useful when user is disabled... it destroys all the sessions of that user
  def authenticatable_salt
  "#{super}#{session_token}"
  end

  def invalidate_all_sessions!
    self.session_token = SecureRandom.hex
  end
   # Custom methods for OmniAuth
   def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
   end
   # def self.from_omniauth(auth)
   #  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
   #    user.email = auth.info.email
   #    user.password = Devise.friendly_token[0,20]
   #    user.name = auth.info.name   # assuming the user model has a name
   #    user.image = auth.info.image # assuming the user model has an image
   #  end
   # end
   # Override the method to support canceled accounts
   # def active_for_authentication? #this was used before for disabled and banned users but i want to display a custom message, so this is now on session controller
   #     super && self.active?
   # end
   def balance
     @orders_total = self.unpaid_orders
     @orders_total.sum(:payout_left)
   end

   def set_defaults
       self.roles = [:user, :employer, :employee]
       set_alias
   end

   def create_user_score
     if self.score.nil?
      UserScore.create do |user_score|
        self.score = user_score
      end
    end
   end

   def set_location
     begin
       loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lon}"
       # Convert the geocoded location provided by the user on signup to valid using our GeoDatabase
       self.city_id = get_city_id_in_db(loc.city, loc.state_name, "MX")
     rescue
       true
     end
   end

   def unban!
     self.update(status: "active")
   end

   def active_orders
     Order.where("(employee_id=? OR employer_id=?)", self, self).where(status: ["pending", "in_progress", "disputed"])
   end

   def active_orders?
     active_orders = Order.where("(employee_id=? OR employer_id=?)", self, self).where(status: ["pending", "in_progress", "disputed"])
     active_orders.any?
   end

   private
   def set_roles
     if self.roles_word.present?
       case self.roles_word
         when "employee"
           self.roles = [:user, :employee]
         when "employer"
           self.roles = [:user, :employer]
           self.tags = []
           self.gigs.published.each do |g|
             g.draft!
           end
         when "employee_employer"
           self.roles = [:user, :employer, :employee]
         when "admin"
           self.roles = (ENV.fetch("RAILS_ENV") == "development")? [:admin] : [:user, :employer, :employee] #cant use this in production
         else
           self.roles = [:user, :employer, :employee] #default option is all (except admin)
       end
     end
   end

   def should_generate_new_friendly_id?
     new_record? || slug.blank? || alias_changed? || super
   end

   def update_time_zone
     @client = GooglePlaces::Client.new(ENV.fetch("GOOGLE_MAP_API"))
     @loc = @client.spots_by_query(self.location).first
     @url = "https://maps.googleapis.com/maps/api/timezone/json?key=#{ENV.fetch("GOOGLE_MAP_API")}&location=#{@loc.lat},#{@loc.lng}&timestamp=#{Time.now.getutc.to_i}"
     @res = JSON.parse(Net::HTTP.get(URI.parse("#{@url}")))
     self.time_zone = @res["timeZoneId"] if TZInfo::Timezone.all_country_zone_identifiers.include? @res["timeZoneId"]
   end

   def enable_disable_stuff
     case status
     when "active"
       self.gigs.each do |g|
         if g.status != "banned"
          g.update(status: "draft")
         end
       end
     when "banned"
       self.gigs.each do |g|
         if g.status != "banned"
           g.update(status: "draft")
         end
       end
       self.requests.each do |r|
         r.with_lock do
           if r.status == "published" || r.status == "in_progress"
             r.update(status: "closed")
           end
         end
       end
       # my_offers = Offer.includes(:request).where(user: self)
       # my_offers.each do |o|
       #   o.with_lock do
       #     if o.request.status == "published"
       #       begin
       #        o.destroy
       #      rescue #offer cant be destroyed because someone hired it
       #        true
       #       end
       #     end
       #   end
       # end
     when "disabled" #cant disale if has active orders
       self.gigs.each do |g|
         if g.status != "banned"
           g.update(status: "draft")
         end
       end
       self.requests.each do |r|
         r.with_lock do
           if r.status == "published"
             r.update(status: "closed")
           end
        end
       end
       # my_offers = Offer.includes(:request).where(user: self)
       # my_offers.each do |o|
       #  o.with_lock do
       #     if o.request.status == "published"
       #       begin
       #        o.destroy
       #      rescue #offer cant be destroyed because someone hired it
       #        true
       #       end
       #     end
       #  end
       # end
     end
   end

   # when a user uses the ally code, decrement the times it can be used
   def decrement_ally_code_times_left
      if self.ally_code.present?
       code_times_left = self.ally_code.times_left
       self.ally_code.update!(times_left: code_times_left - 1)
      else
        true
      end
   end

   def user_disabled?
     status_changed?(to: "disabled")
   end

   def check_running_orders
     errors.add(:base, "No puedes cancelar tu cuenta ya que tienes órdenes activas") if self.active_orders?
   end
end
