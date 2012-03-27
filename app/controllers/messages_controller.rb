require 'juggernaut'
class MessagesController < ApplicationController  
  def index
    @msgs = Message.all[-20..-1]
  end
  
  def create
    @msg = Message.create(params[:message])
    @msg.room_id = params[:room_id]
    if @msg.save
      Juggernaut.publish("channel1", @msg.body)
    end
  end
end
