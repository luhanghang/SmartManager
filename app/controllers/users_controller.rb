class UsersController < ApplicationController
  def keep_alive
    id = session[:user]
    if id
      lu = LoginUser.find_by_user_id(id)
      lu.lasttime = Time.now
      lu.save
      render :text => "1"
    else
      render :text => "0"
    end
  end

  def sign_in
    user = User.find_by_account_and_passwd(params[:account], params[:passwd])
    if user == nil
      render :text => "NOLOGIN"
      return
    end

    lu = LoginUser.find_by_user_id(user.id)
    if lu
      if Time.now - lu.lasttime < 30
        render :text => '0'
        return
      end
    else
      lu = LoginUser.new
      lu.user_id = user.id
    end
    session[:user] = user.id
    session[:role] = user.role.alias
    session[:company] = user.company_id
    lu.session_id = request.session_options[:id]
    lu.logintime = Time.now
    lu.lasttime = lu.logintime
    lu.save
    Log.log(session[:user], "用户登录: #{user.account}")
    company = "联通"
    logo = Company::DEFAULT_LOGO
    if user.company
    	company = user.company.name
    	logo = user.company.logo_uri	
    end
    render :text => "#{user.role.alias}:#{user.privileges}:#{company}-#{user.user_group.name}-#{user.realname}(#{user.account}):#{user.id}:#{logo}"
  end

  def sign_out
    user_id = session[:user]
    if user_id && user_id != ""
      user = User.find(user_id)
      Log.log(user_id, "用户注销: #{user.account}")
      reset_session
      lu = LoginUser.find_by_user_id(user_id)
      lu.destroy if lu
    end
    render :text => ""
  end

  def change_passwd
    new_pass = params[:passwd]
    user = User.find(session[:user])
    user.passwd = new_pass
    user.save
    Log.log(session[:user], "修改密码: #{user.account}")
    render :text => ""
  end
  
  def do_change_passwd
    new_pass = params[:passwd]
    match = params[:passwd1]
    if new_pass != match
    	render :update do |page|
	    	page.replace_html 'message', :text => "两次输入的密码不匹配"
	    end
	    return
    end
    
    if new_pass == nil or new_pass.strip == ''
    	render :update do |page|
	    	page.replace_html 'message', :text => "密码不能为空"
	    end
	    return
    end
    
    user = User.find(session[:user])
    user.passwd = new_pass
    user.save
    Log.log(session[:user], "修改密码: #{user.account}")
    render :update do |page|
      page.replace_html 'message', :text => "密码修改成功"
    end
  end

  def check_sign_in
    user_id = session[:user]
    unless user_id
      render :text => "NOLOGIN"
      return
    end

    lu = LoginUser.find_by_user_id(user_id)
    if lu
      unless lu.session_id == request.session_options[:id] || Time.now - lu.lasttime > 30
        reset_session
        render :text => ''
        return
      end
    else
      lu = LoginUser.new
      lu.user_id = user_id
    end
    lu.session_id = request.session_options[:id]
    lu.logintime = Time.now
    lu.lasttime = lu.logintime
    lu.save

    user = User.find(user_id)
    Log.log(session[:user], "用户登录: #{user.account}")
    company = "联通"
    logo = Company::DEFAULT_LOGO
    if user.company
    	company = user.company.name
    	logo = user.company.logo_uri	
    end
    render :text => "#{user.role.alias}:#{user.privileges}:#{company}-#{user.user_group.name}-#{user.realname}(#{user.account}):#{user.id}:#{logo}"
  end

  def save
    u = nil
    id = params[:id].to_i
    if id > 0
      u = User.find(params[:id])
      u.update_attributes(params[:user])
      u.save
      Log.log(session[:user], "修改用户信息: #{u.account}")
    else
      u = User.new(params[:user])
      c_id = session[:company]
      c_id = nil if c_id == ""
      if c_id
        c = Company.find(c_id)
        c.users << u
      else
        u.save
      end
      Log.log(session[:user], "添加用户: #{u.account}")
    end
    render :text => u.id
  end

  def accounts
    @users = User.find(:all)
  end

  def remove
  	ids = params[:id]
  	ids.each do |id|
    	u = User.find(id)
    	Log.log(session[:user], "删除用户: #{u.account}")
    	u.destroy
    end
    render :text => params[:id]
  end

  def monitor_users
    role = Role.find_by_alias('mo')
    @ug = role.user_groups.find(:first)
    @users = @ug.users
    render :template => 'users/accounts', :type => :builder
  end
end
