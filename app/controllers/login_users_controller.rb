class LoginUsersController < ApplicationController
  def index
    @company = session[:company]
    @login_users = LoginUser.all
  end
end
