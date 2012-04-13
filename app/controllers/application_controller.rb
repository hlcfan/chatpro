class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end
  
  def redirect_referrer_or_default(default)
    redirect_to(request.referrer || default)
  end
end
