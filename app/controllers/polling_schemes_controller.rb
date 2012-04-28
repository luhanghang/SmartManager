class PollingSchemesController < ActionController::Base
  def list
    @schemes = session[:user]? User.find(session[:user].id).polling_schemes : []
  end

  def create
    if session[:user]
      user = User.find(session[:user].id)
      @scheme = PollingScheme.new(params[:scheme])
      user.polling_schemes << @scheme
    end
  end

  def destroy
    if session[:user]
      p = PollingScheme.find(params[:id])
      p.destroy
    end
    render :text => "ok"
  end

  def update
    if session[:user]
      p = PollingScheme.find(params[:id])
      p.update_attributes(params[:scheme])
      p.save
    end
    render :text => "ok"
  end

  def add_item
    if session[:user]
      s = PollingScheme.find(params[:id])
      @item = PollingSchemeItem.new(params[:item])
      s.polling_scheme_items << @item
     end
  end

  def remove_item
    if session[:user]
      p = PollingSchemeItem.find(params[:id])
      p.destroy
    end  
    render :text => "ok"
  end
end
