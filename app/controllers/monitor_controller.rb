class MonitorController < ApplicationController
  def index 
  	unless session[:user]
  		redirect_to '/'
  		return
  	end
  end
  
  def dialog
    id = params[:id]
    @spot = Spot.find(id)
    @gateway = @spot.encoder.gateway
  end
end
