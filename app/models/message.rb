# coding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::SoftDelete
  # include Mongoid::BaseModel

  field :sender, :type => String
  field :body, :type => String
  belongs_to :room

end