class User < ApplicationRecord
  attr_accessor :roles_word
  include ApplicationHelper
  include LinksHelper
  #includes
  #friendly_id
  extend FriendlyId
  #validations
  include LocationFunctions
  #inspects
  include AliasFunctions
  #tags
  include TagRestrictions
  # Avatar image
  mount_uploader :image, AvatarUploader
  #search
  searchkick locations: [:location], language: "spanish"
  # only send these fields to elasticsearch
  def search_data
    {
      tags: tag_list.join(" "),
    }.merge(location: {lat: lat, lon: lng})
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
  validates :available, :inclusion=> { :in => ["Tiempo completo", "Medio tiempo", "Esporádico", "Fin de semana"]}, allow_blank: true
  validates_length_of :name, maximum: 100
  validates_length_of :alias, maximum: 30
  validate :maximum_amount_of_tags, :tag_length
  # validate :location_syntax
  validates_length_of :bio, maximum: 500
  validates_presence_of :alias, :slug
  validates :alias, format: { :with => /\A[a-zA-Z0-9\-\_]+\z/, message: "sólo puede contener caracteres alfanuméricos, guión y guión bajo." }
  validates :name, format: { :with => /\A[a-zA-Z\p{L}\p{M}\s]+\z/, message: "Sólo puede contener letras y espacios" }, :allow_blank => true #allow blank because on creation it doesnt have
  validates_presence_of :name, if: :name_changed?  #dont allow blank again if value is filled
  validate :check_running_orders, if: :user_disabled?, on: :update

  validate :websites

  #validate phone number syntax
  validates :phone_number, :presence => {:message => 'Tienes que proporcionar un numero valido'},
                       :length => { :minimum => 10, :maximum => 25 }, #idk the min and max length, just in case someone wants to enter a big string
                       :allow_blank => true
  after_validation :create_user_score

  # update user timezone if location changed
  before_update :update_time_zone, :if => :lat_changed?
  # update verified gigs when account is verified
  before_update :verify_gigs, :if => :verified_changed?
  before_update :set_roles
  before_update :remove_whitespaces_from_profiles
  #when user is banned, unbanned or disabled...
  after_validation :enable_disable_stuff, :if => :status_changed? #this is after updates so dont refund nothing and reverse everything is some validation fails, it would be a big trouble because refund will send to openpay the request and if validation fails then the status of the order will reset to in progress, for example, and refund was requested... trouble



  # Associations
  # User Score
  belongs_to :score, foreign_key: :score_id, class_name: "UserScore", optional: true

  # ally code in case it has one
  belongs_to :ally_code, optional: true

  before_save :decrement_ally_code_times_left, :if => :ally_code_id_changed?
  # reports
  has_many :reports
  # Ticket system
  has_many :tickets
  has_many :ticket_responses
  #card relations
  has_many :cards
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

  def unpaid_orders(verification="payment_verification_pending")
    Order.where(employee: self, status: "completed", paid_at: nil, payment_verification: verification)
  end

  def noa #name or alias
    (self.name.present?)? self.name : self.alias
  end

  def verify_gigs
      self.gigs.each { |gig| gig.touch }
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birth.year - ((now.month > self.birth.month || (now.month == self.birth.month && now.day >= self.birth.day)) ? 0 : 1)
  end

  def score_average return_number=true
    us = self.score
    if us.employee_score_times == 0.0 && us.employer_score_times == 0.0
      return (return_number)? 0.0 : "N/A"
    elsif us.employer_score_times == 0.0
      sa = us.employee_score_average
    elsif us.employee_score_times == 0.0
      sa = us.employer_score_average
    else
      sa = ( ( us.employee_score_average* us.employee_score_times)+( us.employer_score_average* us.employer_score_times) ) / (us.employer_score_times + us.employee_score_times )
    end
    return sa.round(1)
  end

  def get_hashtag string
    name = (string == "fb")? self.facebook : self.instagram
    #this removes all before .com/ and itself, then removes after any / or ?
    return "@" + name
  end

  def facebook_url
    (self.facebook.present?)? "https://facebook.com/"+ self.facebook : nil
  end
  def instagram_url
    (self.instagram.present?)? "https://instagram.com/"+ self.instagram : nil
  end

  def score_average_times
    us = self.score
    if us.employee_score_times == 0.0 && us.employer_score_times == 0.0
      return 0
    else
      us.employer_score_times + us.employee_score_times
    end
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

   def in_review_balance
     @orders_total = self.unpaid_orders
     @orders_total.sum(:payout_left)
   end

   def balance
     @orders_total = self.unpaid_orders(verification="payment_verification_passed")
     @orders_total.sum(:payout_left)
   end

   def set_defaults
       self.roles = [:user, :employer, :employee]
       set_alias
   end

   def self.who_is_online #shows all the users online
     ids = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
     where(id: ids)
   end

   def online?
     ids = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
     ids.include?(self.id.to_s)
   end


   def create_user_score
     if self.score.nil?
      UserScore.create do |user_score|
        self.score = user_score
      end
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
   def safe_bio
     make_links(CGI::escapeHTML(self.bio)).html_safe #escapes html from user and make our links
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
     begin
       @client = GooglePlaces::Client.new(ENV.fetch("GOOGLE_MAP_API"))
       @loc = @client.spots_by_query(self.location).first
       @url = "https://maps.googleapis.com/maps/api/timezone/json?key=#{ENV.fetch("GOOGLE_MAP_API")}&location=#{@loc.lat},#{@loc.lng}&timestamp=#{Time.now.getutc.to_i}"
       @res = JSON.parse(Net::HTTP.get(URI.parse("#{@url}")))
       self.time_zone = @res["timeZoneId"] if TZInfo::Timezone.all_country_zone_identifiers.include? @res["timeZoneId"]
     rescue
       true
     end
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

   def websites
     if self.website.present?
       errors.add(:base, "El sitio no es una url") if ! url_regex.match?(self.website)
     end
   end
   def remove_whitespaces_from_profiles
      if self.facebook.present?
       #also delete / if stars with it
       self.facebook = self.facebook.delete(' ')
       self.facebook = self.facebook.delete_prefix("/")
      end
     if self.instagram.present?
       self.instagram = self.instagram.delete(' ')
       self.instagram = self.instagram.delete_prefix("/")
     end
   end
end
