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

module Adder
	module_function

	def half(a, b)
		
		s = a ^ b
		c = a & b
		
		return s, c
	end  

	def full(a, b, ci)
		
		s = (ab = a ^ b) ^ ci
		co = (a & b) | (ab & ci)
		
		return s, co
	end  
end

module Subtractor
	module_function

	def halfr(a, b)
		
		d = a ^ b
		bo = ~a & b
		
		return d, bo
	end  

	def full(a, b, bi)
		
		d = (ab = a ^ b) ^ bi
		bo = (~a & b) | (~ab & bi)
		
		return d, bo
	end  
end
