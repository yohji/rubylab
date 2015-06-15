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

require "test/unit"
load "../src/geometry.rb"

class GeometryTest < Test::Unit::TestCase

	def setup
		
		@sq = Square.new(12)
		@tr = Triangle.new([3, 6, 4])
	end

	def test_perimeter

		assert_equal(48, @sq.perimeter)
		assert_equal(13, @tr.perimeter)
	end

	def test_area

		assert_equal(144, @sq.area)
		assert_equal(90, @tr.area.round)
	end
end
