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
  score += frequency_score(letter_map)
  score
end

def find_shift(cipher_bytes)
  plaintexts = (0...256).map do |byte|
    bytes = byte_array_xor(cipher_bytes, [byte]*cipher_bytes.length)
    {string: bytes_to_ascii(bytes), score: score_bytes(bytes), byte: byte}
  end.sort_by { |el| -el[:score] }
  #p plaintexts[0..6].select { |dict| dict[:score] >= 0 }
  plaintexts[0]
end





def vigenere_bytes_decrypt(ciphertext_bytes, key_bytes)
  key_length = key_bytes.length
  full_key_bytes = (key_bytes * (1 + ciphertext_bytes.length/key_length))[0...ciphertext_bytes.length]
  bytes_to_hex(byte_array_xor(ciphertext_bytes, full_key_bytes))
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
