require './helpers.rb'
require 'byebug'


cipherhex = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

p hex_to_utf8(cipherhex)

testhex = "746865206b696420646f6e277420706c6179"
#utf8 version: "the kid don't play"

test_bytes = hex_to_bytes(testhex)
[1, 2, 4, 8, 16, 32, 64].each do |byte|
  compare_byte_array = [byte] * test_bytes.length
  p "#{byte}: #{bytes_to_utf8(byte_array_xor(test_bytes, compare_byte_array))}"
end

#sensible character range: 32..126
#most-reasonable range: 32 (space), 65-90, 97-122 (uppercase, lowercase)
