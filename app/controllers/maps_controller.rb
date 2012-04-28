class MapsController < ApplicationController
  before_filter :check_admin, :except => [:client_list,:list, :list_spots, :web]

  def check_admin
    user = session[:user]
    redirect_to '/' unless user && user.user_group.is_admin?
  end

  def create
    @map = Map.new(params[:map])
    @map.save
    @map.save_image(params[:Filedata])
  end
  
  def create_web
  	@map = Map.new(params[:map])
  	@map.web = 1
    @map.save
  end

  def update
    map = Map.find(params[:id])
    map.update_attributes(params[:map])
    map.save
    map.save_image(params[:Filedata]) if params.has_key?(:Filedata)
    render :text => 'ok'
  end

  def list
    id = params[:id].to_i
    if id == 0
      @maps = Map.top_maps
    else
      @maps = Map.find(id).children
    end
  end

  def client_list
    list
  end

  def destroy
    id = params[:id]
    map = Map.find(id)
    if map.web == 0
    	list = map.tree_data
    	list.each do |m|
      		m.destroy_image
    	end
    end
    map.destroy
    render :text => 'ok'
  end

  def list_spots
    map = Map.find(params[:id])
    @spots = map.map_spots
  end

  def remove_all_spots
    map = Map.find(params[:id])
    map.map_spots.destroy_all
  end

  def web
    if session[:user]
      @spots = session[:spots] || UserGroup.find(session[:user].user_group_id).spots
    else
      redirect_to '/'
      return
    end

    @map_spots = []
    @map = Map.find(params[:id])
    @map.map_spots.each do |spot|
      @spots.each do |s|
        if spot.spot_id == s.id
          @map_spots << spot
          break
        end
      end
    end
  end

  def set_web
    @spots = Spot.find(:all,:order=>:name)
    @map = Map.find(params[:id])
    @map_spots = @map.map_spots
  end

  def gps_trace
    web
    list = [];
    @map_spots.each do |spot|
      record = SpotGPS.find_by_spot_id(spot.spot_id,:order => 'id desc')
      list << {:id=>spot.spot_id, :name => spot.spot.name, :x => record.x ,:y => record.y} if record
    end
    render :update do |page|
      page.call "set_spots", list
    end
  end
end