xml.instruct!
xml.Records do
    if @records
        @records.each do |s|
            xml.Record :id => s.id do
                xml.startHour Utils.date s.start_hour
                xml.startMin Utils.date s.start_min
                xml.endHour Utils.date s.end_hour
                xml.endMin Utils.date s.end_min
                xml.date s.record_date
                xml.state s.state
                xml.error s.error
                xml.pathFile "http://" + @my_host + s.path_file
            end
        end
    end
end