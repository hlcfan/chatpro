# coding: utf-8
class Authorization
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel

  field :provider
  field :uid
  embedded_in :user, :inverse_of => :authorizations

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider  

  def self.create_from_hash(user_id, omniauth)
    self.create!(      
      provider:     omniauth.provider,
      uid:          omniauth.uid,
      access_token: omniauth.credentials.token
    )
  end
end

