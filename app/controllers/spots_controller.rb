class SpotsController < ApplicationController
  def states
  	states = []
  	Gateway.all.each do |g|
  		g.spot_states.each do |ss|
  			s = g.spots.find_by_global_id(ss.spot)
  			states << s.id if s 
  		end
  	end
  	render :text => states.join(',')
  end
  
  def tree_list
  	@local = params[:local]
    @local = "1" if @local.blank? 
  	user = User.find_by_account_and_passwd(params[:account],params[:passwd])
  	if user
    	c = user.company
    	if c
  	  		cs = Company.find_by_is_public(1)
  	  		@group = c.spot_groups.find_by_parent_id(1)
  	  		@gs = cs.spot_groups.find_by_parent_id(1)
  	  		if user.role.alias == 'admin'
  	  			@spots = c.spots + cs.spots
  	  		else
  	  			@spots = user.user_group.spots
      		end
    	else
      		@group = SpotGroup.find(:first)
      		@spots = Spot.find(:all);
    	end
    else
    	render :text => ""
    end
  end
  
  def all
    @local = params[:local]
    @local = "1" if @local.blank? 
  	user = User.find_by_account_and_passwd(params[:account],params[:passwd])
  	cs = Company.find_by_is_public(1)
    if user
      case user.role.alias
        when 'op'
          @spots = user.user_group.spots
        when 'su'
          @spots = Spot.all
        when 'admin'
          @spots = user.company.spots + cs.spots
      end
    else
    	@spots = []	
    end
    xml = '<?xml version="1.0" encoding="UTF-8"?>' << "\n"
    xml << '<Spots>' << "\n"
    	@spots.each do |s|
    		g = s.encoder.gateway
    		if @local == '1'
      			address = g.l_address
    		else
      			address = g.address
    		end
    		unless address.blank?
    			state = '0'
    			state = '1' if g.spot_states.find_by_spot(s.global_id)
    			xml << '  <Spot id="' << s.id.to_s << '" name="' << s.name << '" url="' << s.global_id << '@' << address << ':3050" state="' << state << '"/>' << "\n"
    		end
    	end
    xml << '</Spots>'
    render :text => xml, :content_type => 'application/xml'
  end

  def names
    @gateways = Gateway.find(:all)
    render :action => :all
  end
  
  def get_inf
  	@spot = Spot.find(params[:id])
  end

  def change_parent
    spot = Spot.find(params[:id])
    spot.spot_group_id = params[:parent_id]
    spot.save
    Log.log(session[:user], "修改监控点所属分组: #{spot.name}")
    render :text => "ok"
  end

  def create_presetting
    spot = Spot.find(params[:id])
    @p = spot.create_presetting(params[:presetting])
  end

  def gps_trace
    record = SpotGPS.new
    record.spot_id = params[:id]
    record.x = params[:x]
    record.y = params[:y]
    record.save
    render :text => "ok"
  end
end