class MacController < ApplicationController
	def index
	  c = File.open("/etc/mac")
	  n = c.readline
	  c.close
	  @n = n.delete(":").hex
	end

	def next
	  f = File.new("/etc/mac","w")
	  f.puts params[:id]
	  f.close
	  redirect_to "/mac"
	end
end
