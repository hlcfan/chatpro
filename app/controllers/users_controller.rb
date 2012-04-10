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
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Profile was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
