class SpotGroupsController < ApplicationController
  def list
    c_id = session[:company]
    if c_id && c_id != "" 
  		c = Company.find(c_id)
  	else
  		c = Company.find_by_is_public(1)
  	end 
  	@spots = c.spots(:order => :name)
  	@group = c.spot_groups.find_by_parent_id(1)
  end
  
  def list_with_share
  	c = Company.find(session[:company])
  	@spots = c.spots(:order => :name)
  	@group = c.spot_groups.find_by_parent_id(1)
  	cs = Company.find_by_is_public(1)
  	if cs
  		@gs = cs.spot_groups.find_by_parent_id(1)
  		@ss = cs.spots(:order => :name)
  	end
  end	

  def add
    g = SpotGroup.new(params[:group])
    c_id = session[:company]
    if c_id && c_id != "" 
  		c = Company.find(c_id)
  	else
  		c = Company.find_by_is_public(1)
  	end 
    c.spot_groups << g
    Log.log(session[:user], "新建监控点分组: #{g.name}")
    render :text => g.id
  end

  def list_with_presetting
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
      @spots = Spot.find(:all,:order=>"name")
    end
    @local = params[:local]
    @local = "0" if @local.blank?
  end

  def update
    g = SpotGroup.find(params[:id])
    g.update_attributes(params[:group])
    g.save
    Log.log(session[:user], "修改监控点分组信息: #{g.name}")
    render :text => "ok"
  end

  def remove
    g = SpotGroup.find(params[:id])
    c_id = session[:company]
    if c_id && c_id != "" 
  		c = Company.find(c_id)
  	else
  		c = Company.find_by_is_public(1)
  	end
    root = c.spot_groups.find_by_parent_id(1)
    spots = g.spots
    spots.each do |s|
    	root.spots << s
    end
    Log.log(session[:user], "删除监控点分组: #{g.name}")
    g.destroy
    #Spot.adjust_parent(session[:company])
    render :text => "ok"
  end

  def change_parent
    g = SpotGroup.find(params[:id])
    g.parent_id = params[:parent_id]
    g.save
    render :text => "ok"
  end
end