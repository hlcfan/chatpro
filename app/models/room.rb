class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :desc
  field :password, type: String, :default => ""
  
  has_many :messages, :dependent => :destroy
  has_and_belongs_to_many :users, :class_name => 'User', :inverse_of => :current_user_rooms
  belongs_to :user
  
end