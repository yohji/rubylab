#!/usr/bin/ruby
#
#	Copyright (c) 2018 Marco Merli <yohji@marcomerli.net>
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

require 'io/console'
require 'colorize'

$stats = [0, 0]
$difficulty = 3
$difficulty = ARGV[0].to_i if ARGV.length > 0

print "Typenum v1.0\n".blue
print "Copyright (c) 2018 Marco Merli <yohji@marcomerli.net>\n".blue
print "Difficulty: #{$difficulty}\n\n".blue

def terminate
	
	print "\n\nResult: ".blue
	print "#{$stats[0]}".green
	print "/#{$stats[1]} (".blue
	print "#{(($stats[0] / ($stats[1] * 1.0)) * 100).round}%".green if $stats[1] > 0
	print ")\n".blue
		
	exit
end

while true do
	curr = Random.rand(1000 << ($difficulty * 2.5)).to_s
	print "#{curr}: ".yellow

	buffer = String.new
	while ((digit = STDIN.getch) != nil) do
	
		if digit == "\u007F" and not buffer.empty?
			buffer.chop!
			print "\b \b"
			next
		end
		
		terminate if digit == "\u0003" or digit == "\u001B"
		next if not digit.between?("0", "9")
		
		buffer << digit
		print "*"
		break if buffer.length == curr.length
	end

	$stats[1] += 1
	if buffer == curr
		print " -> OK\n".green
		$stats[0] += 1
	else
		print " -> KO [*: #{buffer}]\n".red
	end
end
