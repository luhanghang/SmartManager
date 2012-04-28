class CompaniesController < ApplicationController
  def index
    @companies = Company.find_all_by_is_public(0)
  end
  
  def visual_modes
  	user_id = session[:user]
    if user_id && user_id != ""
    	user = User.find(user_id)
    	c = user.company
    	if c 
    		render :text => c.visual_modes
    	else
    		render :text => "all"
    	end
    else
    	render :text => "none"
    end	
  end
  
  def gateways
  	c = Company.find(params[:id])
  	@gateways = c.companies_gateways
  end

  def save
    id = params[:id]
    c = nil
    if id and id.to_i > 0
      c = Company.find(id)
      c.update_attributes(params[:company])
      c.save
      Log.log(session[:user]||params[:user_id], "修改公司信息: #{c.name}")
    else
      c = Company.new(params[:company])
      c.save
      sg = SpotGroup.new
      sg.name = c.name
      sg.alias = c.name
      sg.parent_id = 1
      c.spot_groups << sg
      Log.log(session[:user]||params[:user_id], "新建公司信息: #{c.name}")
    end
	c.save_logo(params[:Filedata]) if params.has_key?(:Filedata)
    render :text => c.id
  end
  
  def new_admin
  	u = User.new(params[:user])
    company = Company.find(params[:id])
    ug = company.user_groups.find_by_role_id(UserGroup::ADMIN)
    unless ug
    	ug = UserGroup.new 
      	ug.name = "管理员组"
      	ug.role_id = UserGroup::ADMIN
      	company.user_groups << ug
    end
    ug.users << u
    company.users << u
    Log.log(session[:user], "为公司(#{company.name})新建管理员: #{u.account}")
    render :text => u.id
  end
  
  def admins
  	com = Company.find(params[:id])
  	ug = com.user_groups.find_by_role_id(UserGroup::ADMIN)
  	@accounts = []
  	@accounts = ug.users if ug
  end

  def remove
    id = params[:id]
    c = Company.find(id)
    c.encoders.each do |encoder|
    	encoder.company_id = nil
    	encoder.save
    	g = encoder.gateway.address
    	sg = SpotGroup.find_by_alias(encoder.gateway.address)
    	encoder.spots.each do |spot|
    		spot.company_id = nil
    		sg.spots << spot
    	end	
    end
    Log.log(session[:user], "删除公司信息: #{c.name}")
    c.destroy
    c.destroy_logo
    CompaniesGateway.delete_all("company_id = #{id}")
    render :text => "ok"
  end

  def add_gateway
    cg = CompaniesGateway.new(params[:gateway])
    cg.save
    Log.log(session[:user], "为公司(#{cg.company.name})添加可访问网关: #{cg.gateway.name}")
    render :text => "ok"
  end

  def update_gateway
  	com_id = params[:gateway][:company_id]
  	gw_id = params[:gateway][:gateway_id]
  	c = Company.find(com_id)
  	g = Gateway.find(gw_id)
    #s = CompaniesGateway.find_by_company_id_and_gateway_id(com_id, gw_id)
    CompaniesGateway.update_all("capacity = #{params[:gateway][:capacity]}, concurrency = #{params[:gateway][:concurrency]}","company_id = #{com_id} and gateway_id = #{gw_id}")
    Log.log(session[:user], "修改公司(#{c.name})网关信息: #{g.name}")
    render :text => "ok"
  end

  def remove_gateway
    c = Company.find(params[:id])
    gw_id = params[:gateway_id]
    gateway = c.gateways.find(gw_id)
    Log.log(session[:user], "删除公司(#{c.name})可访问网关: #{gateway.name}")
    c.gateways.delete(gateway) if gateway
    render :text => gw_id
  end
end