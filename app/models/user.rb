class User < ApplicationRecord
  #includes
  #friendly_id
  extend FriendlyId
  #Payments
  include OpenpayFunctions
  include OpenpayHelper
  #validations
  include LocationValidation
  #inspects
  include AliasFunctions
  #Define who can do the rating, which happens to be the user
  ratyrate_rater
  #alias
  friendly_id :alias, use: :slugged
  #if alias changes, also slug
  def should_generate_new_friendly_id?
    alias_changed?
  end
  #enum
  enum status: { active: 0, disabled: 1, banned: 2}
  # Create default values
  after_create :set_defaults
  # Create openpay user
  after_commit :create_openpay_account
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
  # Associations
  # reports
  has_many :reports
  # Chat Relations
  has_many :messages
  # Request System
  has_many :requests
  has_many :offers
  has_many :reviews
  # Gigs
  has_many :gigs
  # Notifications
  has_many :notifications, as: :recipient
  # Orders and sales
  has_many :purchases, class_name: :Order, foreign_key: :employer
  has_many :sales, class_name: :Order, foreign_key: :employee
  #Push subscriptions reference
  has_many :push_subscriptions
  #withdrawals Relations
  has_many :withdrawals
  # likes
  has_many :likes
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
    Dispute.where(order_id: Order.where(user_id: self.id)).or(Dispute.where(order_id: Order.where(employee_id: self.id)))
  end
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:admin, :support, :employer, :employee], multiple: true)                                      ##
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
   # Override the method to support canceled accounts
   def active_for_authentication?
       super && self.active?
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

   def set_defaults
       self.roles = [:user, :employer, :employee]
       set_alias
   end
end
