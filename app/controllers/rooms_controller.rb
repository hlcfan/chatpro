class RoomsController < ApplicationController
  def index
    @rooms = Room.all.to_a
  end
  
  def show
    @room = Room.find(params[:id])    
    @msgs = @room.messages
  end
end
