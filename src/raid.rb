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

class Raid4
	
	BASE_PATH = "/tmp/"
	FILE_PART_1 = BASE_PATH + "%s.part1"
	FILE_PART_2 = BASE_PATH + "%s.part2"
	FILE_PARITY = BASE_PATH + "%s.parity"
	FILE_RESTORE = BASE_PATH + "%s.restore"
	
	def Raid4.store(filepath)
		
		if ! File.exist?(filepath)
			raise IOError, "File '#{filepath}' does not exists."
		end
		
		bytes = File.binread(filepath).unpack("C*")
		filename = File.split(filepath)[1]
		
		part1 = File.new(FILE_PART_1 % filename,
				File::CREAT | File::TRUNC | File::BINARY | File::WRONLY, 0644)
		part2 = File.new(FILE_PART_2 % filename, 
				File::CREAT | File::TRUNC | File::BINARY | File::WRONLY, 0644)
		parity = File.new(FILE_PARITY % filename,
				File::CREAT | File::TRUNC | File::BINARY | File::WRONLY, 0644)
		
		0.step(bytes.size - 1, 2) do |ifile|
			
			a = bytes[ifile]
			part1.write(a.chr)
			
			b = bytes[ifile + 1]
			if b != nil
				part2.write(b.chr)
				parity.write((a ^ b).chr)
			else
				part2.write(a.chr)
				parity.write(0.chr)
			end
		end
		
		part1.close
		part2.close
		parity.close
	end
	
	def Raid4.restore(filename)
		
		e1 = File.exist?(FILE_PART_1 % filename)
		e2 = File.exist?(FILE_PART_2 % filename)
		ep = File.exist?(FILE_PARITY % filename)
		
		if (ep and (e1 or e2)) or (e1 and e2)
		
			restore = File.new(FILE_RESTORE % filename,
					File::CREAT | File::TRUNC | File::BINARY | File::WRONLY, 0644)
			
			if e1 and ep
				
				lbytes = File.binread(FILE_PART_1 % filename).unpack("C*")
				rbytes = File.binread(FILE_PARITY % filename).unpack("C*")
				sz = lbytes.size
				
				sz.times do |ifile|
					restore.write((bl = lbytes[ifile]).chr)
					br = rbytes[ifile]
					restore.write((bl ^ br).chr) unless (ifile == (sz - 1) and br == 0) 
				end
			elsif e2 and ep
				
				lbytes = File.binread(FILE_PART_2 % filename).unpack("C*")
				rbytes = File.binread(FILE_PARITY % filename).unpack("C*")
				sz = lbytes.size
				
				sz.times do |ifile|
					bl = lbytes[ifile]
					br = rbytes[ifile]
					restore.write((bl ^ br).chr)
					restore.write(bl.chr) unless (ifile == (sz - 1) and br == 0) 
				end
			elsif e1 and e2
				
				lbytes = File.binread(FILE_PART_1 % filename).unpack("C*")
				rbytes = File.binread(FILE_PART_2 % filename).unpack("C*")
				sz = lbytes.size
				
				sz.times do |ifile|
					restore.write((lbytes[ifile]).chr)
					br = rbytes[ifile]
					restore.write(br.chr) unless (ifile == (sz - 1) and br == 0) 
				end
			end
			
			restore.close
		else
			raise IOError, "No enough files available."
		end
	end
end