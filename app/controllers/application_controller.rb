# Filters added to this controller apply to names controllers in the application.
# Likewise, names the methods added will be available for names controllers.

class ApplicationController < ActionController::Base
  helper :all # include names helpers, names the time
  protect_from_forgery :only => [] # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
