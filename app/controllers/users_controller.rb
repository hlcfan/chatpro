# coding: utf-8
class UsersController < ApplicationController
	before_filter :authenticate_user!  
  def index
    
  end
  
  def show
    @user = User.find params[:id]
  end

  def edit
  	@user = User.find params[:id]
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
end

