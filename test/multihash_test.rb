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
load "../src/multihash.rb"

class MultiHashTest < Test::Unit::TestCase

	def setup
		
		@map = MultiHash.new
		
		@map.store(1, 11)
		@map.store(1, 12)
		@map.store(2, 21)
		@map.store(2, 22)
		@map.store(2, 23)
		@map.store(3, 31)
	end

	def test_crypt_store

		assert(@map.include?(1))
		assert_equal(3, @map.keys.size)
		assert_equal(6, @map.size)
	end

	def test_crypt_values

		assert_equal([11, 12, 21, 22, 23, 31], @map.values)
		assert_equal([21, 22, 23, 31], @map.values_at(2, 3))
		
		assert(@map.value?(22))
		assert(! @map.value?(34))
	end

	def test_crypt_delete

		@map.delete_value(2, 22)
		@map.delete_value(3, 31)

		assert_equal(4, @map.size)
		assert(! @map.value?(22))
		assert(! @map.value?(31))
	end
end

