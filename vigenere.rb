require './helpers.rb'

ciphertext = File.open("challenge1-6.txt", "r").readlines.map(&:chomp).join()
cipher_bytes = ascii_to_bytes(ciphertext)

CHUNK_SIZE = 3

def compare_chunks(bytes, key_length, first_chunk, second_chunk)
  first_begin = first_chunk*key_length*CHUNK_SIZE
  first_end = (first_chunk+1)*key_length*CHUNK_SIZE
  second_begin = second_chunk*key_length*CHUNK_SIZE
  second_end = (second_chunk+1)*key_length*CHUNK_SIZE
  bytes_hamming(
    bytes[first_begin...first_end], 
    bytes[second_begin...second_end]
  )*1.0/(key_length*CHUNK_SIZE)
end

length_to_score = {}
1.upto(((1 + ciphertext.length ** 0.5)).to_i).each do |key_length|
  length_to_score[key_length] = compare_chunks(cipher_bytes, key_length, 0, 1) +
   compare_chunks(cipher_bytes, key_length, 0, 2) +
   compare_chunks(cipher_bytes, key_length, 1, 2)
end
best_lengths = length_to_score.entries.sort_by {|pair| pair[1]}
p (((1 + ciphertext.length ** 0.5)).to_i)
p best_lengths[0..9]

#this was a mess. best length 32, probably?

def transpose_to_chunks(array, period)
  chunks = Array.new(period) { Array.new() }
  array.each_with_index do |el, idx|
    chunks[idx % period] << el
  end
  chunks
end

def solve_chunks(chunk_array, offset=0)
  key_bytes = []
  chunk_array.each do |chunk|
    key_bytes << find_shift(chunk, offset)[:byte]
  end
  key_bytes
end

10.times do |n|
  key_bytes = solve_chunks(transpose_to_chunks(cipher_bytes, 32),n)
  p key_bytes
  p hex_to_ascii(vigenere_bytes_decrypt(cipher_bytes, key_bytes))
end
