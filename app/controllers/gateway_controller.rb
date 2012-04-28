require 'httpclient'
require 'rexml/document'
include REXML

class GatewayController < ApplicationController

  def add
    g = Gateway.new(params[:gateway])
    g.generate_seq
    g.save
    get_remote_devices(g)
    Log.log(session[:user], "添加网关: #{g.name}")
    render :text => g.seq.to_s << ":" << g.id.to_s
  end

  def register
    seq = params[:id]
    g = Gateway.find_by_seq(seq)
    is_new = false
    unless g
      is_new = true
      g = Gateway.new
      g.generate_seq
    end
    g.name = params[:name]
    g.address = params[:host]
    g.port = params[:port]
    g.web_port = params[:web_port]
    g.apptype = params[:apptype]
    g.driver = params[:driver]
    g.protocal = params[:protocal]
    g.save
    if is_new
      get_remote_devices(g)
    end
    render :text => g.seq.to_s
  end

  def get_remote_devices(gateway)
    g = SpotGroup.find_by_alias(gateway.address)
    unless g
      g = SpotGroup.new
      g.parent_id = 1
      g.name = gateway.address
      g.alias = gateway.address
      g.save
    end
    seq = gateway.seq.to_s
    client = HTTPClient.new
    #devices = client.get_content('http://' << gateway.address << ':' << Gateway::WS_PORT.to_s << '/gateway/get_devices?seq=' << seq)
    devices = client.get_content('http://' << gateway.address << ':' << gateway.port.to_s << '/gateway/get_devices')
    devices = Document.new(devices).root
    devices.elements.each do |encoder_node|
      encoder = Encoder.new
      encoder.seq = encoder_node.attributes['id']
      Encoder.column_names.each do |field|
        encoder[field] = encoder_node.attributes[field] if field != 'id' && encoder_node.attributes[field]
      end
      gateway.encoders << encoder
      encoder_node.elements.each do |spot_node|
        spot = Spot.new
        spot.seq = spot_node.attributes['id']
        Spot.column_names.each do |field|
          spot[field] = spot_node.attributes[field] if field != 'id' && spot_node.attributes[field]
        end
        encoder.spots << spot
        g.spots << spot
      end
    end
  end

  def destroy
    id = params[:id]
    gateway = Gateway.find(id)
    Log.log(session[:user], "删除网关: #{gateway.name}")
    gateway.destroy
    CompaniesGateway.delete_all("gateway_id = #{id}")
    render :text => 'ok'
  end

  def all
    unless session[:company]
      @gateways = Gateway.find(:all)
    else
      @company = Company.find(session[:company])
    end
  end

  def get
    gw_id = params[:id]
    @gateway = Gateway.find(gw_id)
    unless session[:company]
      #@encoders = gateway.encoders
      @encoders = @gateway.encoders.find_all_by_company_id
      @companies = Company.find_all_by_is_public(1) + @gateway.companies 
    else
      @companies = [Company.find(session[:company])]
    end
  end

  def save
    @gateway = Gateway.find(params[:id])
    address = @gateway.address
    #unless save_remote(params[:gateway], '/gateway/save')[:result]
    #  render :text => '-1'
    #  return
    #end
    @gateway.update_attributes(params[:gateway])
    @gateway.save
    sg = SpotGroup.find_by_alias(address)
    sg.alias = @gateway.address
    sg.save
    Log.log(session[:user], "更改网关信息: #{@gateway.name}")
    render :text => '0'
  end

  def save_remote(inf, uri)
    result = true
    client = HTTPClient.new
    client.connect_timeout = 5
    res_content = nil
    begin
      res = client.post('http://' << @gateway.address << ':' << @gateway.port.to_s << uri, inf)
      res_content = res.content
    rescue
      result = false
    end
    return {:result => result, :res => res_content}
  end

  def save_encoder
    encoder = Encoder.find_by_name(params[:encoder][:name])
    @errors = []
    if encoder && encoder.id.to_s != params[:encoder][:id]
      @errors << "编码器名称:\"#{params[:encoder][:name]}\"已存在"
    end

    # encoder = Encoder.find_by_service_port_and_gateway_id(params[:encoder][:service_port], params[:id])
#     @errors = []
#     if encoder && encoder.id.to_s != params[:encoder][:id]
#       @errors << "服务端口:\"#{params[:encoder][:service_port]}\"已被使用"
#     end

    unless @errors.empty?
      return
    end
    @gateway = Gateway.find(params[:id])
    inf = params[:encoder].clone
    dict = Dictionary.new
    device = dict.get_device_inf((inf['device'].to_i + 1).to_s)
    inf['id'] = params[:seq]
    inf['device_name'] = device['name']
    inf['device_type'] = device['type']
    inf['vendor'] = device['vendor']
    inf['guid'] = device['GUID']
    inf['driver'] = device['driver']

    s = save_remote(inf, '/devices/save')
    unless s[:result]
      render :xml => '<failure/>'
      return
    end

    if params[:seq] && params[:seq] != ''
      @encoder = @gateway.encoders.find_by_seq(params[:seq])
      @encoder.update_attributes(params[:encoder])
      @encoder.save
      Log.log(session[:user], "修改编码器信息: #{@encoder.name}")
    else
      seq = Document.new(s[:res]).root.attributes['id']
      @encoder = Encoder.new(params[:encoder])
      @encoder.seq = seq
      @gateway.encoders << @encoder
      Log.log(session[:user], "添加编码器信息: #{@encoder.name}")
    end

    if session[:role] == "admin"
      c = Company.find(session[:company])
      c.encoders << @encoder
    end
  end

  def ping
    client = HTTPClient.new
    client.connect_timeout = 2
    address = params[:address]
    port = params[:port]
    begin
      result = client.get_content('http://' << address << ':' << port << '/upgrade/ping')
      render :text => result
    rescue
      render :text => ""
    end
  end

  def reboot
    client = HTTPClient.new
    client.connect_timeout = 2
    address = params[:address]
    port = params[:port]
    Log.log(session[:user], "重启网关: #{address}")
    begin
      result = client.get_content('http://' << address << ':' << port << '/reboot/')
      render :text => result
    rescue
      render :text => ""
    end
  end

  def apply_setting
    client = HTTPClient.new
    client.connect_timeout = 2
    address = params[:address]
    port = params[:port]
    Log.log(session[:user], "网关应用新设置: #{address}")
    begin
      result = client.get_content('http://' << address << ':' << port << '/apply_setting')
      render :text => result
    rescue
      render :text => ""
    end
  end

  def save_spot
    @errors = []
    spot = Spot.find_by_name(params[:spot][:name])
    if spot && spot.id.to_s != params[:spot][:id]
      @errors << "监控点名称:\"#{params[:spot][:name]}\"已存在"
    end

    spot = Spot.find_by_alias(params[:spot][:alias])
    if spot && spot.id.to_s != params[:spot][:id]
      @errors << "监控点别名:\"#{params[:spot][:alias]}\"已存在"
    end

    unless @errors.empty?
      return
    end

    encoder = Encoder.find(params[:encoder_id])
    @gateway = encoder.gateway
    inf = params[:spot].clone
    inf['id'] = params[:seq]
    inf['encoder_id'] = encoder.seq
    s = save_remote(inf, '/devices/save_spot')
    unless s[:result]
      render :xml => "<failure/>"
      return
    end

    if params[:id] && params[:id] != ''
      @spot = Spot.find(params[:id])
      @spot.update_attributes(params[:spot])
      @spot.save
      Log.log(session[:user], "修改监控点信息: #{@spot.name}")
    else
      @spot = Spot.new(params[:spot])
      result = Document.new(s[:res]).root
      seq = result.attributes['id']
      global_id = result.attributes['global_id']
      @spot.seq = seq
      @spot.global_id = global_id
      encoder.spots << @spot

      c = @spot.company
      if c
        sg = c.spot_groups.find_by_parent_id(1)
      else
        sg = SpotGroup.find_by_alias(@spot.encoder.gateway.address)
      end
      sg.spots << @spot
      Log.log(session[:user], "添加监控点: #{@spot.name}")
    end

    #if session[:role] == "admin"
    #c = Company.find(session[:company])
    #c.spots << @spot
    #end  
  end

  def remove_encoder
    encoder = Encoder.find(params[:id])
    @gateway = encoder.gateway
    inf = {'id' => encoder.seq }
    unless save_remote(inf, '/devices/remove')[:result]
      render :text => "-1"
      return
    end
    encoder.destroy
    Log.log(session[:user], "删除编码器: #{encoder.name}")
    render :text => "0"
  end

  def remove_spot
    spot = Spot.find(params[:id])
    @gateway = spot.encoder.gateway
    inf = {'id' => spot.seq }
    unless save_remote(inf, '/devices/remove_spot')[:result]
      render :text => "-1"
      return
    end
    spot.destroy
    Log.log(session[:user], "删除监控点: #{spot.name}")
    render :text => "0"
  end

  def summary
    @gateways = Gateway.find(:all)
  end
  
  def spot_states
  	client = HTTPClient.new
  	Gateway.all.each do |g|
  		begin
  			states = client.get_content('http://' << g.address << ':' << g.port.to_s << '/spots/states')
    		states = states.chop.split(',')
    		local_ss = []
    		g.spot_states.each do |ss|
    			unless states.member?(ss.spot)
    				ss.destroy
    			else
    				local_ss << ss.spot
    			end
    		end
    		states.each do |s|
    			unless local_ss.member?(s)
    				ss = SpotState.new
    				ss.spot = s
    				g.spot_states << ss
    			end
    		end
    	rescue
    		states = '' 
    	end
  	end
  	render :text => ""
  end
  
  def query_apply
  	file = File.new('config/config.ini','r')
  	config = file.read
  	config = config.strip.split('=')[1]
  	file.close
  	render :text => config
  end
  
  def toggle_apply
  	enable = params[:id]
  	file = File.new('config/config.ini','w')
  	file.puts "enable_apply=#{enable}"
  	file.close
  	render :text => enable
  end
end
