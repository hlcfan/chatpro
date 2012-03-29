class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :desc
  
  has_many :messages  
  has_and_belongs_to_many :users, :class_name => 'User', :inverse_of => :current_user_rooms
  
end