class User < ApplicationRecord
  extend FriendlyId
  include OpenpayHelper
  include LocationValidation
  friendly_id :alias, use: :slugged

  enum status: { active: 0, disabled: 1, blocked: 2}

  # Validates uniqueness of id
  validates :email, :alias,  uniqueness: true
  validates_numericality_of :age, greater_than: 17, less_than: 101, allow_blank: true
  validates :available, :inclusion=> { :in => ["Tiempo completo", "Medio tiempo", "Esporádico", "Fin de semana"]}, allow_blank: true
  validates_length_of :name, maximum: 100
  validates_length_of :location, maximum: 100
  validate :location_syntax
  validates_length_of :bio, maximum: 500
  # Avatar image
  mount_uploader :image, AvatarUploader

  # reports
  has_many :reports

  # Chat Relations
  has_many :messages

  # Request System
  has_many :requests
  has_many :offers
  # Gigs
  has_many :gigs
  # Notifications
  has_many :notifications, as: :recipient

  # Orders and sales
  has_many :purchases, class_name: :Order, foreign_key: :user
  has_many :sales, class_name: :Order, foreign_key: :receiver

  #Push subscriptions reference
  has_many :push_subscriptions

  #Define who can do the rating, which happens to be the user
  ratyrate_rater

  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'

  #withdrawals Relations
  has_many :withdrawals

  # likes
  has_many :likes
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:admin, :support], multiple: false)                                      ##
  ############################################################################################


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


   # Custom methods for OmniAuth
   def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
   end

   def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
   end

   def should_generate_new_friendly_id?
     alias_changed?
   end

   #  Deactivate user only instead of deleting
   def destroy
     @user_gigs = Gig.where(user_id: self.id)
     @user_gigs.each do |gig|
       (gig.published?)? gig.draft! : nil
     end
     @user_requests = Request.where(user_id: self.id)
     @user_requests.each do |request|
       request.closed!
     end
     disabled!
     update_attributes(openpay_id: "0")
   end

   # Create default values
   after_initialize :set_defaults
   after_save :create_openpay_account

   # Override the method to support canceled accounts
   def active_for_authentication?
       super && self.active?
   end

   def conversations
     Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
   end

   def disputes
     Dispute.where(order_id: Order.where(user_id: self.id)).or(Dispute.where(order_id: Order.where(receiver_id: self.id)))
   end

   def balance
     @balance = 0.0
     @order_ids = []
     @refunded = self.purchases.refunded.where(paid_at: nil)
     @sales = self.sales.completed.where(paid_at: nil)
     @join = @sales + @refunded
     @join.each do |b|
       @balance += b.total
       @order_ids << b.id
     end
     return {amount: @balance, order_ids: @order_ids}
   end

   def likes?(gig)
     gig.likes.where(user: self).any?
   end

   private

   def set_defaults
       # self.role ||= "user"
       set_alias
   end

   def set_alias
     if self.alias.nil?
       login_part = self.email.split("@").first
       hex = SecureRandom.hex(3)
       self.alias = "#{ login_part }-#{ hex }"
     end
   end

   def create_openpay_account
     # Create openpay Account if not already there
     if self.openpay_id.nil?
       init_openpay("customer")

       # Create default hash for new user
       request_hash={
         "name" => self.alias,
         "last_name" => nil,
         "email" => self.email,
         "requires_account" => false
       }

       begin
         response_hash = @customer.create(request_hash.to_hash)
         self.openpay_id = response_hash['id']
         save
       rescue OpenpayTransactionException => e
          puts "#{self.alias} issue: #{e.description}, so the user could not be created on openpay"
       end
     end
   end

end
