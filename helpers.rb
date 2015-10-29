require './hexto64.rb'
require './xor.rb'

#hex_to_bytes(hexstring)
#bytes_to_hex(hex_array)
#byte_array_xor(bytes1, bytes2)
#hex_string_xor(hex1, hex2)
#
#hex_to_base64(hexstring)

def hex_to_utf8(hexstring)
  [hexstring].pack("H*")
end

def bytes_to_utf8(byte_array)
  byte_array.pack("C*")
end

def utf8_to_bytes(text)
  text.unpack("C*")
end

##english letter frequency table
#def frequency_table()
#  table = { e: 21912, t: 16587, a: 14810, o: 14003, i: 13318, n:12666,
#   s: 11450, r: 10977, h: 10795, d: 7874, l: 7253, u: 5246, c: 4943, 
#   m: 4761, f: 4200, y: 3853, w: 3819, g: 3693, p: 3316, b: 2715, v: 2019,
#   k: 1257, x: 315, q: 205, j: 188, z: 128, total: 182303 }
#end
#
def frequency_order
  [' '] + %w[e t 0 a o i n s h r d l c u m w f g y p b v k j x q z]
end
