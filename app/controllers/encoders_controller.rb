class EncodersController < ApplicationController
  def get_inf
    @encoder = Encoder.find(params[:id])
  end

  def change_company
    encoder = Encoder.find(params[:id])
    c_id = params[:company]
    c_id = nil if c_id == ''
    encoder.company_id = c_id
    encoder.save
    company = nil
    company = Company.find(c_id) if c_id
    if company
      sg = company.spot_groups.find_by_parent_id(1)
    else
      sg = SpotGroup.find_by_alias(encoder.gateway.address)
    end

    Spot.update_all({:company_id => company, :spot_group_id => sg.id}, [ "encoder_id = ?", encoder.id])
    if company
      c_name = company.name
    else
      c_name = "总部"
    end
    Log.log(session[:user], "将编码器: #{encoder.name}分配给公司:#{c_name}")
    render :text => 'ok'
  end
end
