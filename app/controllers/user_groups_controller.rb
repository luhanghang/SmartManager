class UserGroupsController < ApplicationController
  def all
    c = Company.find(session[:company])
    role = Role.find_by_alias('op')
    @groups = c.user_groups.find_all_by_role_id(role)
    #@groups = UserGroup.find(:all, :order => :id)
    #@g = UserGroup.ungrouped
  end

  def get
    id = params[:id]
    c = Company.find(session[:company])
    @sg_root = c.spot_groups.find_by_parent_id(1)
    @g = UserGroup.find(id)
    cs = Company.find_by_is_public(1)
    @sgs = cs.spot_groups.find_by_parent_id(1) if cs
  end

  def save
    id = params[:id]
    g = nil
    if id and id.to_i > 0
      g = UserGroup.find(id)
      g.update_attributes(params[:group])
      g.save
      Log.log(session[:user], "修改用户组信息: #{g.name}")
    else
      g = UserGroup.new(params[:group])
      c = Company.find(session[:company])
      c.user_groups << g
      r = Role.find 3
      r.user_groups << g
      Log.log(session[:user], "新建用户组: #{g.name}")
    end
    render :text => g.id
  end

  def link_spots
    ids = params[:spot_id]
    c = Company.find(session[:company])
    @sg_root = c.spot_groups.find_by_parent_id(1)
    if ids
      @g = UserGroup.find(params[:id])
      @g.spots << Spot.find(params[:spot_id])
    end
    cs = Company.find_by_is_public(1)
    @sgs = cs.spot_groups.find_by_parent_id(1)
    Log.log(session[:user], "添加用户组可访问监控点: #{@g.name}")
  end

  def remove_spots
    ids = params[:spot_id]
    if ids
      g = UserGroup.find(params[:id])
      g.spots.delete(g.spots.find(params[:spot_id]))
    end
    c = Company.find(session[:company])
    @sg_root = c.spot_groups.find_by_parent_id(1)
    @g = UserGroup.find(params[:id])
    cs = Company.find_by_is_public(1)
    @sgs = cs.spot_groups.find_by_parent_id(1)
    Log.log(session[:user], "删除用户组可访问监控点: #{@g.name}")
  end

  def link_users
    users = User.find(params[:user_id])
    id = params[:id]
    if id == "0"
      User.ungroup_users(users)
    else
      g = UserGroup.find(id)
      g.users << users
    end
    Log.log(session[:user], "修改用户所属用户组: #{g.name}")
    render :text => "ok"
  end

  def remove
    g = UserGroup.find(params[:id])
    #User.ungroup_users(g.users)
    Log.log(session[:user], "删除用户组: #{g.name}")
    g.destroy
    render :text => "ok"
  end
end
