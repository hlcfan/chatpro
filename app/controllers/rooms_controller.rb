class RoomsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @rooms = Room.all.to_a
  end
  
  def show
    @room = Room.find(params[:id])
    @msgs = @room.messages
    @users_online = User.where(:online_status => 1).to_a
  end
  
  def new
    @room  = Room.new
  end
  
  def create
    @room = Room.create(params[:room])
  end
end
