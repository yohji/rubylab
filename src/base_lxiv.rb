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

class BaseLXIV
	
	BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	def self.encode(str)
		
		if str == ""
			return str
		end
		
		enc = String.new
		bytes = str.unpack("C*")
		
		0.step(bytes.size - 1, 3) do |bi|
			buffer = 0x0
			
			offset = 24
			(tok = bytes[bi, 3]).each do |b|
				buffer |= b << (offset -= 8)
			end
			
			enc += BASE64_CHARS[(buffer >> 18) & 0x3f]
			enc += BASE64_CHARS[(buffer >> 12) & 0x3f]
			enc += BASE64_CHARS[(buffer >> 6) & 0x3f]
			enc += BASE64_CHARS[buffer & 0x3f]
			
			if (tok.size == 1)
				enc[enc.size - 2, enc.size] = '='
				enc += '='
				
			elsif (tok.size == 2)
				enc[enc.size - 1, enc.size] = '='
			end
		end
		
		return enc
	end
	
	def self.decode(str)
		
		dec = String.new
		
		buffer = 0x0
		offset = 24
		
		str.each_char do |ch|
			
			if ch == '='
				break
			end
			
			buffer |= BASE64_CHARS.index(ch) << (offset -= 6)
			
			if offset == 0
				
				dec += ((buffer >> 16) & 0xff).chr
				dec += ((buffer >> 8) & 0xff).chr
				dec += (buffer & 0xff).chr
				
				buffer = 0x0
				offset = 24
			end
		end
		
		if buffer != 0
			dec += ((buffer >> 16) & 0xff).chr
			dec += ((buffer >> 8) & 0xff).chr
		end
		
		return dec
	end
	
	def self.encode_stream(str)
		
		if str == ""
			return str
		end
		
		enc = String.new
		remainder = 0x0
		bi = 0
		
		str.each_byte do |b|
			p = bi % 3
			
			if p == 0
				enc += BASE64_CHARS[b >> 2]
				remainder = b & 0x3
				
			elsif p == 1
				enc += BASE64_CHARS[remainder << 4 | b >> 4]
				remainder = b & 0xf
				
			else
				enc += BASE64_CHARS[remainder << 2 | b >> 6]
				enc += BASE64_CHARS[b & 0x3f]
				remainder = -1
			end
			
			bi = bi.next
		end
		
		
		if remainder != -1
			if ((bi - 1) % 3) == 0
				enc += BASE64_CHARS[remainder << 4]
			else
				enc += BASE64_CHARS[remainder << 2]
			end
		end
		
		enc += "=" * ((str.bytesize * 8) % 3)
		
		return enc
	end
	
end
