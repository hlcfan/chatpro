# coding: utf-8
class UsersController < ApplicationController
	before_filter :authenticate_user!  
  def index
    
  end
  
  def show
    @user = User.find params[:id]
    @title = @user.username
    @meta_desc = "Info About #{@user.username}"
  end

  def edit
    if current_user.id.eql?(params[:id])
      @user = User.find params[:id]       
    else
      @user = current_user
    end
    @title = "Edit Settings - #{current_user.username}"      
  end
  
  def update
  	@user = User.find params[:id]
    @user.weibo_id = params[:user][:weibo_id]
    @user.website = params[:user][:website]
    @user.email = params[:user][:email]
    @user.facebook_id = params[:user][:facebook_id]
    @user.twitter_id = params[:user][:twitter_id]
    @user.github_id = params[:user][:github_id]
    @user.googleplus_id = params[:user][:googleplus_id]
    @user.stackoverflow_id = params[:user][:stackoverflow_id]
    @user.intro = params[:user][:intro]
    if @user.save
      redirect_to(@user, :notice => 'Profile was successfully updated.')
    else
      render :action => :edit
    end
  end

  def fav_room
    room = Room.find params[:id]
    current_user.fav_rooms << room
    redirect_to :back
  end

  def unfav_room
    room = Room.find params[:id]
    current_user.fav_rooms.delete(room)
    redirect_to :back
  end

  def update_password
    @user = User.find(current_user.id)
      if @user.update_attributes(params[:user])
        # Sign in the user bypassing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to root_path
      else
        render "edit"
      end
  end

end

