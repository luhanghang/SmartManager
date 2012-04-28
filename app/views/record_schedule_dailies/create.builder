xml.instruct!
xml.Schedule :id => @schedule.id do
  xml.startHour Utils.date @schedule.start_hour
  xml.startMin Utils.date @schedule.start_min
  xml.endHour Utils.date @schedule.end_hour
  xml.endMin Utils.date @schedule.end_min
  xml.lastTime @schedule.last_time
  xml.enabled @schedule.enabled
  xml.scheduleDate @schedule.schedule_date
  xml.color @schedule.color
end