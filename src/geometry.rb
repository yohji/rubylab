#!/usr/bin/ruby

#
#	Copyright (c) 2014 Marco Merli <yohji@marcomerli.net>
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

class Polygon

	attr_reader(:nSides, :lenSides)
	
	def initialize(nSides, lenSides=nil)
		
		@nSides = nSides
		if lenSides.nil?
	 		@lenSides = Array.new(nSides)
		else
			@lenSides = lenSides
		end
	end

	def perimeter
		
		perimeter = 0
		lenSides.each do |side|
			perimeter += side
		end
		return perimeter	
	end
end


class EquilateralPolygon < Polygon
	
	def initialize(nSides, lenSide)
		
		super(nSides)

		i = 0
		@nSides.times do
			@lenSides[i] = lenSide
			i += 1
		end
	end
	
end


class Triangle < Polygon
	
	def initialize(lenSides)

		super(3, lenSides)
	end

	def area

		p = perimeter
		a = lenSides[0]
		b = lenSides[1]
		c = lenSides[2]
		
		return Math.sqrt(
			p * (p - a) * (p - b) * (p - c))
	end
end


class Square < EquilateralPolygon

	def initialize(lenSide)
		
		super(4, lenSide)
	end

	def area
		
		return lenSides[0] ** 2
	end
end
