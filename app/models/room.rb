class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :desc
  
  has_many :messages
end