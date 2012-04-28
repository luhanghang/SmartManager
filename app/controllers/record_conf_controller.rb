class RecordConfController < ApplicationController
  def read
	file = File.new('config/record.xml','r')
	conf = file.read
	file.close
	render :text => conf
  end

  def save
	file = File.new('config/record.xml','w')
	file.puts(params[:xml])
	file.close
	render :text => '1'
  end
end
