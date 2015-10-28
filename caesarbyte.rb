require './helpers.rb'
require 'byebug'


cipherhex = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

#testhex = "746865206b696420646f6e277420706c6179"
##utf8 version: "the kid don't play"

#sensible character range: 32..126
#most-reasonable range: 32 (space), 65-90, 97-122 (uppercase, lowercase)

def frequency_score(character_hash)
  frequency_order.each_with_index.map {|el, idx| [el, idx]}.sort_by do |pair|
    -character_hash[pair[0]] end.each_with_index.map do |pair, idx|
      (pair[1] - idx).abs
    end.inject(&:+) * (1 + character_hash.values.inject(&:+)/10)
end

def score_bytes(byte_array)
  score = 0
  letter_map = {}
  frequency_order.each { |letter| letter_map[letter] = 0 }
  byte_array.each do |byte|
    if (7..13).include?(byte)
      next
    elsif byte < 32 or byte > 126
      score -= 100
      next
    elsif byte == 32 or (65..90).include?(byte) or (97..122).include?(byte)
      score += 10
    end
    if (33..64).include?(byte) or (91..96).include?(byte) or byte > 122
      letter_map['0'] += 1
    else
      letter_map[byte.chr.downcase] += 1
    end
  end
  score += frequency_score(letter_map)
end

#test_bytes = hex_to_bytes(testhex)
#[1, 2, 4, 8, 16, 32, 64].each do |byte|
#  compare_byte_array = [byte] * test_bytes.length
#  xored_array = byte_array_xor(test_bytes, compare_byte_array)
#  p "#{byte}: #{bytes_to_utf8(xored_array)}, score: #{score_bytes(xored_array)}"
#end
