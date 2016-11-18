#!/usr/bin/ruby

#
#	Copyright (c) 2015 Marco Merli <yohji@marcomerli.net>
#   
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program; if not, write to the Free Software Foundation,
#	Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

require "socket"

HOSTNAME="127.0.0.1"

class Provider
	
	def initialize(port)
		
		@port = port
		
	end
	
	def start
		
		@server = TCPServer.open(HOSTNAME, @port)
		@daemon = Thread.start do
			loop { handle }
		end
		
		return self
	end
	
	def stop
		
		Thread.kill(@daemon)
		@server.shutdown
	end
	
	def handle
		
		Thread.start(@server.accept) do |client|
			puts "provider: #{client.addr}"
			
			client.puts(Time.now.ctime)
			client.close
		end
	end
end

class Consumer
	
	def Consumer.call(port)
		
		sock = TCPSocket.open(HOSTNAME, port)
		
		while line = sock.gets
			puts "consumer: #{line.chop}"
		end
		
		sock.close
	end
end
