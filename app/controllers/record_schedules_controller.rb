class RecordSchedulesController < ApplicationController
  def create
    days = params[:days]
    @schedules = []
    days.each do |day|
      rs = RecordSchedule.new(params[:RecordSchedule])
      rs.week_day = day
      rs.save
      @schedules << rs
    end
    render :action => "list.builder"
  end

  def update
    s = RecordSchedule.find(params[:id])
    s.update_attributes(params[:RecordSchedule])
    s.save
    render :text => 'ok'
  end

  def list
    spot = Spot.find(params[:id])
    @schedules = spot.record_schedules
  end

  def destroy
    s = RecordSchedule.find(params[:id])
    s.destroy()
    render :text => 'ok'
  end

  def destroy_all
    spot = Spot.find(params[:id])
    spot.record_schedules.delete_all
    render :text => 'ok'
  end
end
