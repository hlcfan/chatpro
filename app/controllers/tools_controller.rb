class ToolsController < ApplicationController
	USER_NAME, PASSWORD = 'hlcfan', '123456'
  before_filter :authenticate#, :except => [:index, :show]
	def index
		
	end

	def user_list
		@users = User.all.paginate(:page => params[:page], :per_page => 50)
	end

	def message_mgmt
		@msgs = Message.all.paginate(:page => params[:page], :per_page => 50)
	end

	def show_msg
		@msg = Message.find params[:msg_id]

	end

	private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == USER_NAME && password == PASSWORD
    end
  end
end
