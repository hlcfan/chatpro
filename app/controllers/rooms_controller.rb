class RoomsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @rooms = Room.all.to_a
  end
  
  def show
    @room = Room.find(params[:id])
    @msgs = @room.messages[-20..-1]
    @room.user_ids.append(current_user.id)
    @room.save
    @users_online = @room.users
    @hot_replies = Message.desc(:vote_user_ids).limit(10).to_a
  end
  
  def new
    @room  = Room.new
  end
  
  def create
    @room = Room.create(params[:room])
  end
  
  def leave
    @room = Room.find(params[:room_id])
    @room.user_ids.delete(current_user.id)
    @room.save
    redirect_to root_path
  end
end
