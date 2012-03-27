# coding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Redis::Objects
  extend OmniauthCallbacks
  cache
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  attr_accessible :name, :email, :password, :password_confirmation
         
  ## Database authenticatable
  field :name, :type => String, :null => false
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  
  field :location
  field :location_id, :type => Integer
  
  index :name
  index :email
  index :location
  
  def self.find_for_open_id(access_token, signed_in_resource=nil)
  data = access_token.info
  if user = User.where(:email => data["email"]).first
    user
  else
    User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
  end
end
  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
end