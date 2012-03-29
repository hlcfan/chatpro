# coding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::SoftDelete
  # include Mongoid::BaseModel

  #field :sender, :type => String
  field :body, :type => String  
  belongs_to :room
  belongs_to :user, :class_name => 'User', :inverse_of => :message_user
  has_and_belongs_to_many :vote_users, :class_name => 'User', :index => true, :inverse_of => :user_vote_messages  

end