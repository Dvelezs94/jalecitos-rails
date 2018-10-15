class User < ApplicationRecord
  # Chat Relations
  has_many :messages
  has_many :conversations, foreign_key: :sender_id

  # Request System
  has_many :requests
  has_many :offers
  # Gigs
  has_many :gigs

  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:admin, :support], multiple: false)                                      ##
  ############################################################################################


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
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

   # Create default values
   before_create :set_defaults

   private
   def set_defaults
       # self.role ||= "user"
       set_alias
   end

   def set_alias
     login_part = self.email.split("@").first
     hex = SecureRandom.hex(3)
     self.alias = "#{ login_part }-#{ hex }"
   end
end
