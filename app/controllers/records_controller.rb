require 'httpclient'

class RecordsController < ApplicationController
  def query 
  	unless session[:user]
  		render :text => 'access_denied'
  		return
  	end
  	id = params[:id]
  	if id == nil or id == ''
  		render :text => 'access_denied'
  		return
  	end	
  	@spot = Spot.find(id)
  	if @spot == nil 
  		render :text => 'access_denied'
  		return
  	end	
  	
  	@role = session[:role]
  	spots = []
  	c_id = session[:company]
    c_id = nil if c_id == ''
  	if c_id
  	  c = Company.find(c_id)
  	  cs = Company.find_by_is_public(1)
  	  @group = c.spot_groups.find_by_parent_id(1)
  	  @gs = cs.spot_groups.find_by_parent_id(1) if cs
  	  if @role == 'admin'
  	  	if cs
  	  		spots = c.spots + cs.spots
  	  	else
			spots = c.spots
  	  	end
  	  else
  	  	user = User.find(session[:user])
      	spots = user.user_group.spots
      end
    end
    
  	unless spots.include?(@spot) or session[:role] == 'su'
  		render :text => 'access_denied'
  		return
  	end
  	@date = params[:date]
  	if @date == nil or @date == ''
  		@date = Time.now.strftime('%Y-%m-%d')
  	end
  	result = Record.get_by_spot_and_date(@spot, @date)
  	if result == nil
  		@records = []
  		@nvr = ''
  	else
  		@records = result[:records]
  		@nvr = result[:nvr]
  	end
  end
  
  def play
  	@title = params[:title]
  	@nvr = params[:nvr]
  	@pathFile = params[:pathFile]
  end
  
  def remove
  	render :update do |page|
  		if session[:role] == 'su'
  			spot = Spot.find(params[:id])
  			gateway = spot.encoder.gateway
		  	client = HTTPClient.new
		    nvr = client.get_content('http://' << gateway.l_address << ':' << gateway.port.to_s << '/record_conf/read')
		    client.get_content('http://' << nvr << '/record_files/remove/' << spot.global_id << '?remote_ip=' << gateway.l_address)
  		end
  		page.call 'alert', "删除任务已提交至删除队列，系统将自动进行删除"
    end
  end
end
