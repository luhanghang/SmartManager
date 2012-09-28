class Record
  require 'httpclient'
  require 'rexml/document'
  include REXML

  def self.get_by_spot_and_date(spot, date = nil)
  	result = {}
  	records = []
  	if date == nil or date == '' 
  		return nil
  	end
  	gateway = spot.encoder.gateway
  	client = HTTPClient.new
    nvr = client.get_content('http://' << gateway.l_address << ':' << gateway.port.to_s << '/record_conf/read')
    result[:nvr] = nvr
    xml = client.get_content('http://' << nvr << '/record_files/search/' << spot.global_id << '?from_date=' << date << '&to_date=' << date << '&remote_ip=' << gateway.l_address)	
    _records = Document.new(xml).root
    _records.elements.each do |_record|
    	record = {}
    	record['id'] = _record.attributes['id']
    	_record.elements.each do |el|
	    record[el.name] = el.text
	    end
    	records << record		
    end
    result[:records] = records
    return result
  end
end