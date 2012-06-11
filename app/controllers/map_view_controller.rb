class MapViewController < ApplicationController
	def index 
		@user_id = session[:user]
    	c_id = session[:company]
    	c_id = nil if c_id == ''
    	if c_id
  	  		c = Company.find(c_id)
  	  		cs = Company.find_by_is_public(1)
  	  		@group = c.spot_groups.find_by_parent_id(1)
  	  		@gs = cs.spot_groups.find_by_parent_id(1) if cs
  	  		if session[:role] == 'admin'
  	  			if cs
  	  				@spots = c.spots + cs.spots
  	  			else
					@spots = c.spots
  	  			end
  	  		else
  	  			user = User.find(session[:user])
      			@spots = user.user_group.spots
      		end
    	else
      		@group = SpotGroup.find(:first)
      		@spots = Spot.find(:all);
    	end
    	@local = params[:local]
    	@local = "0" if @local.blank?
	end
end