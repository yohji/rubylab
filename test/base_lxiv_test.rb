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

require "test/unit"
require "base64"
require "benchmark"
load "../src/base_lxiv.rb"

TEXT="This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA."

class BaseLXIVTest < Test::Unit::TestCase

	def test_diff
		
		base64, lxiv = nil
		
		puts Benchmark.measure { base64 = Base64.strict_encode64(TEXT) }
		puts Benchmark.measure { lxiv = BaseLXIV.encode(TEXT) }
		
		assert_equal(base64.size, lxiv.size);
		assert_equal(base64, lxiv);
		
		puts Benchmark.measure { base64 = Base64.strict_decode64(base64) }
		puts Benchmark.measure { lxiv = BaseLXIV.decode(lxiv) }
		
		assert_equal(base64.size, lxiv.size);
		assert_equal(base64, lxiv);
	end
end
