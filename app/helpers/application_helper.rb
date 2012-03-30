module ApplicationHelper
	def markdown(text)		
		markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    :autolink => true, :filter_html => true, :hard_wrap => true)
    if text.include?("<input")
    	text
    else
			raw markdown.render(text)
		end
	end
end
