require './helpers.rb'

ciphertext = File.open("challenge1-6.txt", "r").readlines.map(&:chomp).join()
cipher_bytes = ascii_to_bytes(ciphertext)

1.upto(((1 + ciphertext ** 0.5)/2).to_i).each do |key_length|

end
