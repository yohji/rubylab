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

class CaesarCipher

	SHIFT = 4
	NUM_OFFSET = 48
	CHAR_OFFSET = 65

	def CaesarCipher.crypt(str)

		enc = String.new
		str = str.upcase

		str.each_char do |ch|
			n = ch.ord

			if n >= NUM_OFFSET and n < (NUM_OFFSET + 10)
				n = (((n - NUM_OFFSET) + SHIFT) % 10) + NUM_OFFSET
				
			elsif n >= CHAR_OFFSET and n < (CHAR_OFFSET + 26)
				n = (((n - CHAR_OFFSET) + SHIFT) % 26) + CHAR_OFFSET
			end
	
			enc += n.chr(Encoding::UTF_8)
		end

		return enc
	end

	def CaesarCipher.decrypt(str)

		dec = String.new
		str = str.upcase

		str.each_char do |ch|
			n = ch.ord

			if n >= NUM_OFFSET and n < (NUM_OFFSET + 10)
				n = (((n - NUM_OFFSET) - SHIFT) % 10) + NUM_OFFSET
				
			elsif n >= CHAR_OFFSET and n < (CHAR_OFFSET + 26)
				n = (((n - CHAR_OFFSET) - SHIFT) % 26) + CHAR_OFFSET
			end
	
			dec += n.chr(Encoding::UTF_8)
		end

		return dec
	end
end

class AutoshiftCipher
	
	NUM_OFFSET = 48
	UPCHAR_OFFSET = 65
	DNCHAR_OFFSET = 97
	
	def AutoshiftCipher.crypt(str)

		enc = String.new

		shift = 1
		str.each_char do |ch|
			n = ch.ord

			if n >= NUM_OFFSET and n < (NUM_OFFSET + 10)
				n = (((n - NUM_OFFSET) + shift) % 10) + NUM_OFFSET
				
			elsif n >= UPCHAR_OFFSET and n < (UPCHAR_OFFSET + 26)
				n = (((n - UPCHAR_OFFSET) + shift) % 26) + UPCHAR_OFFSET
				
			elsif n >= DNCHAR_OFFSET and n < (DNCHAR_OFFSET + 26)
				n = (((n - DNCHAR_OFFSET) + shift) % 26) + DNCHAR_OFFSET
			end
	
			enc += n.chr(Encoding::UTF_8)
			
			shift = shift.next % 10
			if shift == 0
				shift += 1
			end
		end

		return enc
	end

	def AutoshiftCipher.decrypt(str)

		dec = String.new

		shift = 1
		str.each_char do |ch|
			n = ch.ord

			if n >= NUM_OFFSET and n < (NUM_OFFSET + 10)
				n = (((n - NUM_OFFSET) - shift) % 10) + NUM_OFFSET
				
			elsif n >= UPCHAR_OFFSET and n < (UPCHAR_OFFSET + 26)
				n = (((n - UPCHAR_OFFSET) - shift) % 26) + UPCHAR_OFFSET
				
			elsif n >= DNCHAR_OFFSET and n < (DNCHAR_OFFSET + 26)
				n = (((n - DNCHAR_OFFSET) - shift) % 26) + DNCHAR_OFFSET
			end
	
			dec += n.chr(Encoding::UTF_8)
			
			shift = shift.next % 10
			if shift == 0
				shift += 1
			end
		end

		return dec
	end
end

class DazeCipher

	def initialize(key)
		
		@key = (key % 255)
	end

	def crypt(str)

		bytes = Array.new

		str.each_byte do |b| # 8bit
			
			buffer = 0x0 # 16bit
			offset = 0
			
			8.times do |bi|

				if ((@key >> bi) & 0x1) == 0x1
					buffer |= 0x1 << offset
					offset += 1
				end
				
				buffer |= ((b >> bi) & 0x1) << offset
				offset += 1
			end
			
			# printf("%s+%s \t=> %s\n", b.to_s(2), @key.to_s(2), buffer.to_s(2))
			bytes << buffer
		end

		return bytes.pack("S*")
	end

	def decrypt(str)

		res = String.new
		bytes = str.unpack("S*")
		
		bytes.each do |b| # 16bit
			
			buffer = 0x0 # 8bit
			offset = 0
			
			8.times do |bi|
				
				if ((@key >> bi) & 0x1) == 0x1
					offset += 1
				end
				
				buffer |= ((b >> offset) & 0x1) << bi
				offset += 1
			end
			
			# printf("%s-%s \t=> %s\n", b.to_s(2), @key.to_s(2), buffer.to_s(2))
			res += buffer.chr(Encoding::UTF_8)
		end
		
		return res
	end
	
	def key(str)
		
		key = 0xffff
		bytes = str.unpack("S*")
		
		bytes.each do |b| # 16bit
			key &= b
		end
		
		last = 0
		foreign = 0x0
		16.times do |bi|
			
			cur = (key >> bi) & 0x1
			if cur == 0 and last == 1
				foreign |= 0x1 << bi
			end
			
			if (key >> (bi + 1)) == 0
				break
			end
			
			last = cur
		end
		
		if foreign != 0
			
			buffer = 0x0
			offset = 0
			16.times do |ifb|
				
				if (foreign >> ifb) & 0x1 == 1
					next
				end
				
				buffer |= ((key >> ifb) & 0x1) << offset
				offset += 1
			end
			
			key = buffer
		end
		
		return key
	end
end

class XorCipher
	
	def XorCipher.crypt(str, key)
		
		res = String.new
		bytes = str.unpack("S*")
		
		bytes.each do |b| # 16bit
			buffer = (b ^ key)
			res += (buffer & 0xff).chr
			res += (buffer >> 8).chr
		end
		
		return res
	end
	
	def XorCipher.decrypt(str, key)
		
		res = String.new
		bytes = str.unpack("S*")
		
		bytes.each do |b| # 16bit
			buffer = (b ^ key)
			res += (buffer & 0xff).chr
			res += (buffer >> 8).chr
		end
		
		return res
	end
end
