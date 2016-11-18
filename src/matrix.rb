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

require 'curses'

Curses.init_screen
Curses.start_color
Curses.nonl
Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)

class Matrix < Array
	
	def next_line
		
		line = Array.new
		Curses.cols.times do
			n = 96 + rand(27)
			line << ((n % 2 == 0) ? n.chr : " ")
		end

		self.shift if (self.size >= Curses.lines)
		self << line
	end
end

@main_window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
@main_window.color_set(1)
@main_window.keypad(true)
@main_window.refresh

matrix = Matrix.new
while true
	matrix.next_line
	
	matrix.each_with_index do |line, il|
		line.each_with_index do |col, ic|
			
			@main_window.setpos(il, ic)
			@main_window << col.to_s
		end
	end
	
	@main_window.refresh
	sleep(0.05)
end
