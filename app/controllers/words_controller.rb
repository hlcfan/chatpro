class WordsController < ApplicationController

	def index
		@msgs = current_user.vote_messages.paginate :page => params[:page], :per_page => 20 || []
	end

	def destroy
		@id = params[:id]
    current_user.vote_message_ids.delete(params[:id].to_i)    
    current_user.save
    #current_user.save
    # respond_with do |format|
    #   format.html { redirect_referrer_or_default words_path }
    #   format.js { render :layout => false }
    # end
  end
end
