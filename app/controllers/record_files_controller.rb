class RecordFilesController < ApplicationController
  def search
    from_date = params[:from_date]
    to_date = params[:to_date]
    conditions = "record_date >= '#{from_date}' and record_date <= '#{to_date}'"
    @my_host = request.host_with_port
    @records = RecordFile.find_all_by_spot_id(params[:id],:conditions => conditions)
  end

  def play
    @record = RecordFile.find(params[:id])
	spot = @record.spot
    @title = "#{spot.name} #{@record.record_date} #{Utils.date @record.start_hour}:#{Utils.date @record.start_min}-#{Utils.date @record.end_hour}:#{Utils.date @record.end_min}"
  end
end
