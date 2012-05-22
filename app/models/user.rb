# coding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Redis::Objects
  extend OmniauthCallbacks
  
  include Gravtastic
  gravtastic

  cache
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  attr_accessor :login
  
  attr_accessible :login, :username, :email, :password, :password_confirmation
         
  ## Database authenticatable
  field :username, :type => String, :null => false
  field :email,              :type => String, :null => false, :default => ""
  field :twitter_id, :type => String, :default => "" 
  field :facebook_id, :type => String, :default => ""
  field :github_id, :type => String, :default => ""
  field :googleplus_id, :type => String, :default => ""
  field :stackoverflow_id, :type => String , :default => ""
  field :website, :type => String , :default => ""
  field :weibo_id, :type => String , :default => ""
  field :intro, :type => String , :default => ""
  field :custom_ids, :type => Array, :default => []

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
  field :online_status, :type => Integer, :default => 0

  
  field :location
  field :location_id, :type => Integer
  
  has_many :admin_rooms, :class_name => 'Room'
  has_and_belongs_to_many :fav_rooms, :class_name => 'Room', :index => true, :inverse_of => :fav_rooms
  has_and_belongs_to_many :rooms, :class_name => 'Room', :inverse_of => :current_room_users
  has_and_belongs_to_many :vote_messages, :class_name => 'Message', :index => true, :inverse_of => :vote_users
  
  index :username
  index :email
  index :location

  has_many :notifications, :class_name => 'Notification::Base', :dependent => :delete

  def read_notifications(notifications)
    unread_ids = notifications.find_all{|notification| !notification.read?}.map(&:_id)
    if unread_ids.any?
      Notification::Base.where({
        :user_id => id,
        :_id.in  => unread_ids,
        :read    => false
      }).update_all(:read => true)
    end
  end
  
  def notify_count
    self.notifications.where(:read => false).length
  end

  def msgs_count
    Message.where(:user_id => self.id).length
  end

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  end
  
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