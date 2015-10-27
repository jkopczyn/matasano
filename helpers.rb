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
