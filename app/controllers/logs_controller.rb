class LogsController  < ApplicationController
	def index
		date_from = "#{params[:date_from][0..9]} #{params[:hour_from]}"
		date_from = get_datetime(date_from)
		date_to = "#{params[:date_to][0..9]} #{params[:hour_to]}"
		date_to = get_datetime(date_to)
		conditions = " and created_at > '#{date_from}' and created_at < '#{date_to}'"
		conditions << " and user_name like '%#{params[:user_name]}%'" unless params[:user_name] == ""
		conditions << " and account like '%#{params[:account]}%'" unless params[:account] == ""
		conditions << " order by created_at desc"
		unless session[:company]
			@logs = Log.find_by_sql("select * from logs where company_id is null#{conditions}")
		else
			@logs = Log.find_by_sql("select * from logs where company_id = #{session[:company]}#{conditions}")
		end
	end
	
	def get_datetime(str)
		#return str
		b = str.to_datetime
		b = b.ago 8.hours
		return b.strftime('%Y-%m-%d %H:%M:%S')
	end
end
