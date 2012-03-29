require 'juggernaut'
require 'kramdown'
class MessagesController < ApplicationController  
  before_filter :authenticate_user!
  def index
    @msgs = Message.all[-20..-1]
  end
  
  def create
    @msg = Message.new
    @msg.body = Kramdown::Document.new(params[:message][:body]).to_html
    @msg.room_id = params[:room_id]
    @msg.user_id = current_user.id
    if @msg.save
      Juggernaut.publish(@msg.room_id, { :username => @msg.user.username, :msg => @msg.body, :timestamp => @msg.created_at.strftime("%H:%M") })
    end
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
end
