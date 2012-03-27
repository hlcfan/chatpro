require 'juggernaut'
class MessagesController < ApplicationController  
  before_filter :authenticate_user!
  def index
    @msgs = Message.all[-20..-1]
  end
  
  def create
    @msg = Message.create(params[:message])
    @msg.room_id = params[:room_id]
    @msg.user_id = current_user.id
    if @msg.save
      Juggernaut.publish(@msg.room_id, @msg.user.email + ":" + @msg.body)
    end
  end
end
