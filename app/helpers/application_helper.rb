# coding: utf-8
module ApplicationHelper	
  def title_helper
    if @title.nil?
      @title = "Talk Around IT"
    end
    "#{@title} | ChatPro"
  end
  
  def meta_helper
    @meta_desc || "ChatPro,Instant Talk For IT People"
  end

end
