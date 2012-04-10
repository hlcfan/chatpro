class RoomsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!
  def index
    @rooms = Room.all.to_a
    #reset_session
  end
  
  def show    
    @room = Room.find(params[:id])
    if session["#{params[:id]}_#{current_user.email}"] == 1 || @room.password.nil? || @room.password == ""
      @msgs = @room.messages.order(:_id => :desc).paginate(:page => params[:page], :per_page => 30)
      @page = @room.messages.length/20 + 1 
      @room.user_ids.append(current_user.id)
      @room.save
      @users_online = []
      @room.users.each do |user|
        @users_online << user.username
      end
      @hot_replies = Message.desc(:vote_user_ids).limit(10).to_a
    else
      render :action => "goto"
    end
    #render :text => "<script>window.open('http://localhost:3000/rooms/#{@room.id}?page=#{@page}')</script>" ,:mime_type => Mime::Type.lookup("application/javascript")
  end
  
  def new
    @room  = Room.new
  end
  
  def create
    @room = Room.create(params[:room])
    @room.user = current_user
    @room.save
    redirect_to room_path(@room)
  end

  def edit
    @room  = Room.find params[:id]
  end    
    
  def update
    @room  = Room.find params[:id]
    if @room.update_attributes(params[:room])
      redirect_to(@room)
    end
  end

  def destroy
    @room  = Room.find params[:id]
    if @room.user.id == current_user.id
      @room.destroy
    end
    redirect_to root_path    
  end

  def leave
    @room = Room.find(params[:room_id])
    @room.user_ids.delete(current_user.id)
    @room.save
    session.delete "1_#{current_user.email}"    
    redirect_to root_path
  end

  #verify Form
  def verify    
    @room = Room.find(params[:id])
    pwd = params[:password]
    if pwd == @room.password
      session_maker 1
      redirect_to room_path(@room)
    else
      render :action => "goto"
    end        
  end

  #show room verify form
  def goto
    @room = Room.find(params[:id])
    if @room.password.nil? || @room.password == ""
      session_maker 1
      redirect_to room_path(@room)
    else
      render :action => "goto"
    end
  end
  
  def session_maker(flag)
    session["#{params[:id]}_#{current_user.email}"] = flag
  end
end
