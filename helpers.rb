require './hexto64.rb'
require './xor.rb'

#hex_to_bytes(hexstring)
#bytes_to_hex(hex_array)
#byte_array_xor(bytes1, bytes2)
#hex_string_xor(hex1, hex2)
#
#hex_to_base64(hexstring)

def hex_to_ascii(hexstring)
  [hexstring].pack("H*")
end

def bytes_to_ascii(byte_array)
  byte_array.pack("C*")
end

def ascii_to_bytes(text)
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

def vigenere(plaintext, key)
  key_bytes = ascii_to_bytes(key)
  key_length = key_bytes.length
  plaintext_bytes = ascii_to_bytes(plaintext)
  full_key_bytes = (key_bytes * (1 + plaintext_bytes.length/key_length))[0...plaintext_bytes.length]
  bytes_to_hex(byte_array_xor(plaintext_bytes, full_key_bytes))
end

def bytes_hamming(bytes1, bytes2)
  byte_array_xor(bytes1, bytes2).map {|n| "%08b" % n }.join("").count("1")
end
