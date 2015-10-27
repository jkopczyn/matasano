require './hexto64.rb'
require 'byebug'

def hex_to_bytes(hexstring)
  [hexstring].pack("H*").unpack("C*")
end

def hex_string_xor(hex1, hex2)
  bytes1 = hex_to_bytes(hex1)
  bytes2 = hex_to_bytes(hex2)
  bytes1.each_with_index.map { |el, idx| el ^ bytes2[idx] }
end

def bytes_to_hex(byte_array)
  byte_array.pack("C*").unpack("H*")[0]
end

p bytes_to_hex(hex_string_xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965"))

