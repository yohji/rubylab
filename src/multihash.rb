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


class MultiHash < Hash

	def store(key, value)
		
		values = self[key]
		if values.nil?
			self[key] = values = Array.new
		end

		values.push value
	end

	def values

		values = Array.new
		keys.each do |k|
			self[k].each do |v|
				values.push v
			end
		end
		
		return values
	end
	
	def values_at(*keys)
	
		values = Array.new
		keys.each do |k|
			if self.keys.include? k
				self[k].each do |v|
					values.push v
				end
			end
		end
		
		return values
	end

	def delete_value(key, value)
		
		if has_key? key

			self[key].delete value
			if self[key].empty?
				delete key
			end
		end
	end

	def size

		size = 0
		keys.each do |k|
			size += self[k].size
		end
		
		return size
	end

	def has_value?(value)

		keys.each do |k|
			self[k].each do |v|
				if v == value
					return true
				end
			end				
		end

		return false
	end

	alias :value? :has_value?
end
