class RecordScheduleDailiesController < ApplicationController
  def create
    @schedule = RecordScheduleDaily.new(params[:RecordSchedule])
    @schedule.save
  end

  def update
    s = RecordScheduleDaily.find(params[:id])
    s.update_attributes(params[:RecordSchedule])
    s.save
    render :text => 'ok'
  end

  def list
    spot = Spot.find(params[:id])
    @schedules = spot.record_schedule_dailies
  end

  def destroy
    s = RecordScheduleDaily.find(params[:id])
    s.destroy()
    render :text => 'ok'
  end

  def destroy_all
    RecordScheduleDaily.delete_all({:spot_id => params[:id], :schedule_date => params[:date]})
    render :text => params[:date]
  end
end
