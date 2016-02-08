require 'byebug'
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

#english letter frequency table
def frequency_table()
  table = { e: 21912, t: 16587, a: 14810, o: 14003, i: 13318, n:12666,
   s: 11450, r: 10977, h: 10795, d: 7874, l: 7253, u: 5246, c: 4943, 
   m: 4761, f: 4200, y: 3853, w: 3819, g: 3693, p: 3316, b: 2715, v: 2019,
   k: 1257, x: 315, q: 205, j: 188, z: 128, total: 182303 }
end
def frequency_order
  [' '] + %w[e t 0 a o i n s h r d l c u m w f g y p b v k j x q z]
end

def score_frequency(expected, actual)
  return -20 unless actual and actual != 0
  multiple = (actual > expected) ? actual/expected : expected/actual
  begin
  [-20, 10+-10*Math.log(multiple)].max
  rescue Exception => e
    puts "expected: #{expected} actual: #{actual}"
    raise e
  end
end

def total_frequency_score(character_hash)
  total_score = 0
  expectations = frequency_table
  expectations.keys.each do |character|
    next if character == :total
    begin
      if character_hash[:total] > 0
        char_score = score_frequency(
          1.0*expectations[character]/expectations[:total],
          0.0005 + 1.0*character_hash[character]/character_hash[:total]
          #fudge so that low-frequency characters don't add tons of negative mass
        ) 
        total_score += char_score 
      end
     #p character
     #p (1.0*expectations[character]/expectations[:total])/(0.0005 + 1.0*character_hash[character]/character_hash[:total])
     #p char_score
     #debugger
    rescue Exception => e
      debugger
      raise e
    end
  end
  #puts "frequency_score: #{total_score}"
  total_score
end

def score_bytes(byte_array)
  score = 0
  letter_map = {"total": 0}
  frequency_order.each { |letter| letter_map[letter.to_sym] = 0 }
  byte_array.each do |byte|
    if [0,9,10,13].include?(byte)
      next
    elsif byte < 32 or byte > 126
      score -= 10000
      next
    elsif byte == 32 or (65..90).include?(byte) or (97..122).include?(byte)
      score += 100
    end
    if (33..64).include?(byte) or (91..96).include?(byte) or byte > 122
      letter_map['0'.to_sym] += 1
      score += 10
    else
      letter_map[byte.chr.downcase.to_sym] += 1
    end
    letter_map[:total] += 1
  end
  begin
    score += total_frequency_score(letter_map)
  rescue Exception => e
    debugger
    raise e
  end
  score
end

def find_best_shifts(cipher_bytes)
  plaintexts = (0...256).map do |byte|
    bytes = byte_array_xor(cipher_bytes, [byte]*cipher_bytes.length)
    begin
      {string: bytes_to_ascii(bytes), score: score_bytes(bytes), byte: byte}
    rescue Exception => e
      debugger
      raise e
    end
  end.sort_by { |el| -el[:score] }
  #p plaintexts[0..6].select { |dict| dict[:score] >= 0 }
  plaintexts
end

def find_shift(cipher_bytes, offset=0)
  find_best_shifts(cipher_bytes)[offset]
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
rescue Exception => e
  debugger
  raise e
end
