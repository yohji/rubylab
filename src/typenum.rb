#!/usr/bin/env ruby

require 'io/console'
require 'colorize'

$stats = [0, 0]

def terminate
	
	print "\n\nResult: ".yellow
	print "#{$stats[0]}".green
	print "/#{$stats[1]} (".blue
	print "#{(($stats[0] / ($stats[1] * 1.0)) * 100).round}%".green
	print ")\n".blue
		
	exit
end

while true do
	curr = Random.rand(8 << 13).to_s
	$stats[1] += 1
	print "#{curr}: ".yellow

	buffer = String.new
	while ((digit = STDIN.getch) != nil) do
		terminate if digit == "\u0003"
		
		buffer << digit
		print "*"
		break if buffer.length == curr.length
	end

	if buffer == curr
		print " -> OK\n".green
		$stats[0] += 1
	else
		print " -> KO\n".red
	end
end
