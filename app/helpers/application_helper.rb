# coding: utf-8
module ApplicationHelper	
  def title_helper
    if @title.nil?
      @title = "Talk Anytime Anywhere"
    end
    "#{@title}" || "ChatPro - Talk Anytime Anywhere"
  end
  
  def meta_helper
    @meta_desc || "ChatPro - Talk Anytime Anywhere"
  end  
end
