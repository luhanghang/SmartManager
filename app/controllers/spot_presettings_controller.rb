class SpotPresettingsController < ActionController::Base
  def list
    @presettings = SpotPresetting.find(:all)
  end

  def destroy
    p = SpotPresetting.find(params[:id])
    p.destroy
    render :text => "ok"
  end

  def update
    p = SpotPresetting.find(params[:id])
    p.update_attributes(params[:presetting])
    p.save
    render :text => "ok"
  end
end
