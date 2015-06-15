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
load "../src/cipher.rb"

TEXT="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class CaesarCipherTest < Test::Unit::TestCase

	def test_crypt
		secret = CaesarCipher.crypt(TEXT)
		plain = CaesarCipher.decrypt(secret)

		assert_equal(TEXT.upcase, plain)
	end
end

class AutoshiftCipherTest < Test::Unit::TestCase

	def test_crypt
		secret = AutoshiftCipher.crypt(TEXT)
		plain = AutoshiftCipher.decrypt(secret)

		assert_equal(TEXT, plain)
	end
end

class DazeCipherTest < Test::Unit::TestCase

	def test_crypt
		
		(1 ... 255).each do |key|
			ciph = DazeCipher.new(key) 
			secret = ciph.crypt(TEXT)
			plain = ciph.decrypt(secret)
			
=begin
			(0 .. TEXT.size).each do |ich|
				if TEXT[ich] != plain[ich]
					printf(
						"%s[%d] > %s == %s\n", 
						TEXT[ich], ich, TEXT[ich].ord.to_s(2), 
						plain[ich].ord.to_s(2))
					
					break
				end
			end
=end
			
			assert_equal(TEXT.size, plain.size)
			assert_equal(TEXT, plain)
			
			brKey = ciph.key(secret)
			
			assert_equal(key, brKey)
		end
	end
end

class XorCipherTest < Test::Unit::TestCase

	def test_crypt
		
		(1 .. 9999).each do |key|
			
			secret = XorCipher.crypt(TEXT, key)
			plain = XorCipher.decrypt(secret, key)
			
			assert_equal(TEXT.size, plain.size)
			assert_equal(TEXT, plain, "key: #{key}")
		end
	end
end
