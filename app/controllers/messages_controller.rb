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
    if params[:message][:body].length <= 600
      @msg.body = link_mention_user params[:message][:body]
      @msg.room_id = params[:room_id]
      @msg.user_id = current_user.id
      @msg.room.update_attributes(:active_date => Time.now)
      username = @msg.user.username
      user_id = @msg.user.id
      room = @msg.room
      users_online = []
      notify_flag = false        
      @msg.room.users.each do |user|
        users_online << user.username 
      end
      
      if @msg.save          
        @msg.mentioned_user_ids.each do |u_id|
          if room.user_ids.include?(u_id)
            User.find(u_id).notifications.where(:message_id => @msg.id, :read => false).first.update_attributes(:read => true)
          end
        end             
        Juggernaut.publish(@msg.room_id, { :user_id => user_id, 
          :username => username, 
          :msg_id => @msg.id, 
          :msg => @msg.body_html.html_safe, 
          :timestamp => @msg.created_at.strftime("%H:%M:%S %Y-%m-%d"), 
          :online => users_online, 
          :notify_users => @msg.mentioned_user_ids,
          :user_avatar => "<img height='50' width='50' src='#{current_user.gravatar_url}'>" 
          })
      end
      render :text => "ok"
    else
      render :js => "alert('Too Long Message');"
    end
  end

  def share
    @msg = Message.find(params[:msg_id])
  end

  def tencent_share
    @msg = Message.find(params[:id])
    begin
      tencent = Tqq_2::Tweet.new(current_user.auth_token, current_user.openid)
      text = Nokogiri::HTML(@msg.body).text
      tencent.add("#{@msg.user.username}:#{text} - #{@msg.room.name} http://hlcfan.tk/rooms/#{@msg.room.id}")
      render :js => "$('#edit_form').modal('hide')"
    rescue Exception => e
      logger.error "Tencent Weibo Share Error #{e.backtrace}"      
    end
  end

  def destroy
    msg = Message.find params[:id]
    msg.destroy
    redirect_to :back
  end
  
  private
  def markdown(text)    
    assembler = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    :autolink => true, :filter_html => true, :hard_wrap => true)
      assembler.render(text.gsub("\n","\n\n"))  
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
      text.gsub!(/(^|[^a-zA-Z0-9_!#\$%&*@＠])@([a-zA-Z0-9_]{1,20}|(.+?)\s+)|@/io) { 
        %(#{$1}<a href="/users/#{$2}" class="at_user" title="@#{$2}"><i>@</i>#{$2}</a>)
      }
    else
      text
    end
  end

end
