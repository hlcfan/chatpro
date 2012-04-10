# coding: utf-8
require 'juggernaut'

class MessagesController < ApplicationController  
  before_filter :authenticate_user!
  helper :application
  def index
    @msgs = Message.all[-20..-1]
  end
  
  def create
    @msg = Message.new
    @msg.body = link_mention_user params[:message][:body]
    @msg.room_id = params[:room_id]
    @msg.user_id = current_user.id
    username = @msg.user.username
    users_online = []
    notify_flag = false
    #notifications = []
    @msg.room.users.each do |user|
      users_online << user.username 
    end
    
    if @msg.save    
      # current_user.notifications.each do |notify|
      #   notifications << notify.user_id
      # end      
      Juggernaut.publish(@msg.room_id, { :username => username, :msg_id => @msg.id, :msg => blacklist(markdown(@msg.body)), :timestamp => @msg.created_at.strftime("%H:%M"), :online => users_online, :notify_users => @msg.mentioned_user_ids })
    end
    render :text => "ok"   
  end

  def vote
    msg = Message.find(params[:msg_id])
    unless msg.vote_user_ids.include?(current_user.id)
      msg.vote_users << current_user
      msg.save
      render :js => "alert('thx,man')"
    else
      render :js => "alert('you have voted,man')"
    end    
  end

  private
  def markdown(text)    
    assembler = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    :autolink => true, :filter_html => true, :hard_wrap => true)
      assembler.render(text)  
  end

  DISALLOWED_TAGS = %w(script iframe input form) unless defined?(DISALLOWED_TAGS)

  def blacklist(html)
    # only do this if absolutely necessary    
    if html.index("<")
      tokenizer = HTML::Tokenizer.new(html)
      new_text = ""

      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        new_text << case node
                    when HTML::Tag
                      if DISALLOWED_TAGS.include?(node.name)
                        node.to_s.gsub(/</, "&LT;")
                      else
                        node.to_s
                      end
                    else
                      node.to_s.gsub(/</, "&LT;")
                    end
      end

      html = new_text
    end
    html
  end
  
  def link_mention_user(text)
    if text.include?("@")
      text.gsub!(/(^|[^a-zA-Z0-9_!#\$%&*@＠])@([a-zA-Z0-9_]{1,20}|(.+?)\s+)/io) { 
        %(#{$1}<a href="/users/#{$2}" class="at_user" title="@#{$2}"><i>@</i>#{$2}</a>)
      }
    else
      text
    end
  end
end
