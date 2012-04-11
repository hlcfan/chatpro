# coding: utf-8
require "digest/md5"
class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::SoftDelete
  include Mongoid::BaseModel
  #include Mongoid::MarkdownBody

  #field :sender, :type => String
  field :body, :type => String  
  field :body_html
  field :mentioned_user_ids, :type => Array, :default => []

  belongs_to :room
  belongs_to :user, :class_name => 'User', :inverse_of => :message_user
  has_and_belongs_to_many :vote_users, :class_name => 'User', :index => true, :inverse_of => :user_vote_messages  
  
  has_many :notifications, :class_name => 'Notification::Base', :dependent => :delete

  attr_accessible :body
  validates_presence_of :body

  before_save :extract_mentioned_users
  def extract_mentioned_users
    usernames = body.scan(/@(\w{3,20})/).flatten
    if usernames.any?
      self.mentioned_user_ids = User.where(:username => /^(#{usernames.join('|')})$/i).limit(5).only(:_id).map(&:_id).to_a
    end
  end

  ## kind of no throught
  # def mentioned_user_names
  #   # 用于作为缓存 key
  #   ids_md5 = Digest::MD5.hexdigest(self.mentioned_user_ids.to_s)
  #   Rails.cache.fetch("reply:#{self.id}:mentioned_user_names:#{ids_md5}") do
  #     User.where(:_id.in => self.mentioned_user_ids).only(:login).map(&:login)
  #   end
  # end

  after_create :send_mention_notification #, :send_topic_reply_notification
  def send_mention_notification
    self.mentioned_user_ids.each do |user_id|
      Notification::Mention.create :user_id => user_id, :message => self
    end
  end

  # def send_topic_reply_notification
  #   if self.user != topic.user && !mentioned_user_ids.include?(topic.user_id)
  #     Notification::TopicReply.create :user => topic.user, :reply => self
  #   end
  # end

end