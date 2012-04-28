class MapSpotsController < ApplicationController
  def create
    destroy
    @s = MapSpot.new(params[:spot])
    @s.save
  end

  def update
    s = MapSpot.find_by_spot_id_and_map_id(params[:spot][:spot_id], params[:spot][:map_id])
    s.update_attributes(params[:spot])
    s.save
  end

  def destroy
    s = MapSpot.find_by_spot_id_and_map_id(params[:spot][:spot_id], params[:spot][:map_id])
    s.destroy if s
  end
end