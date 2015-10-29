require './helpers.rb'
require 'byebug'


cipherhex = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
cipher_bytes = hex_to_bytes(cipherhex)

#sensible character range: 32..126
#most-reasonable range: 32 (space), 65-90, 97-122 (uppercase, lowercase)

def frequency_score(character_hash)
  frequency_pairs = frequency_order.each_with_index.map {|el, idx| [el, idx]}
  critical_indices = (0..7).to_a + frequency_pairs[-5..-1].map {|el| el[1]}
  frequency_pairs.sort_by do |pair|
    -character_hash[pair[0]] end.each_with_index.map do |pair, idx|
     critical_indices.include?(idx) ? (pair[1] - idx).abs : 0
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
  #score += frequency_score(letter_map)
  score
end

plaintexts = (0...256).map do |byte|
  bytes = byte_array_xor(cipher_bytes, [byte]*cipher_bytes.length)
  {string: bytes_to_utf8(bytes), score: score_bytes(bytes), byte: byte}
end.sort_by { |el| -el[:score] }
p plaintexts[0..6].select { |dict| dict[:score] >= 0 }

#testhex = "746865206b696420646f6e277420706c6179"
##utf8 version: "the kid don't play"
#test_bytes = hex_to_bytes(testhex)
#[1, 2, 4, 8, 16, 32, 64, 128, 256].each do |byte|
#  compare_byte_array = [byte] * test_bytes.length
#  xored_array = byte_array_xor(test_bytes, compare_byte_array)
#  p "#{byte}: #{bytes_to_utf8(xored_array)}, score: #{score_bytes(xored_array)}"
#end

