require './helpers.rb'

ciphertext = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
#ciphertext = File.open("challenge1-6.txt", "r").readlines.map(&:chomp).join()
cipher_bytes = hex_to_bytes(ciphertext)

CHUNK_SIZE = 3

def compare_chunks(bytes, key_length, first_chunk, second_chunk)
  first_begin = first_chunk*key_length*CHUNK_SIZE
  first_end = (first_chunk+1)*key_length*CHUNK_SIZE
  second_begin = second_chunk*key_length*CHUNK_SIZE
  second_end = (second_chunk+1)*key_length*CHUNK_SIZE
  return if second_end >= bytes.length or first_end >= bytes.length
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

solutions = []
1.upto(12) do |key_length|
  3.times do |n|
    key_bytes = solve_chunks(transpose_to_chunks(cipher_bytes, key_length),n)
    #p key_bytes
    #p hex_to_ascii(vigenere_bytes_decrypt(cipher_bytes, key_bytes))
    solutions << [key_bytes, vigenere_bytes_decrypt(cipher_bytes, key_bytes)]
  end
end
puts "Best are:"
((solutions.sort_by {|pair| -score_bytes(hex_to_bytes(pair[1])) }.map do |pair| 
  [pair[0], bytes_to_ascii(pair[0]), score_bytes(hex_to_bytes(pair[1])), hex_to_ascii(pair[1])] 
end)[0...10]).each { |el| p el }

puts "Vs. 'ICE'"
ice = ascii_to_bytes("ICE")
plain_bytes = hex_to_bytes(vigenere_bytes_decrypt(cipher_bytes, ice))
puts "[#{ice}, \"ICE\", #{score_bytes(plain_bytes)}, #{bytes_to_ascii(plain_bytes)}"

#plaintext = "Praesent sollicitudin, nunc vitae gravida malesuada, diam risus auctor purus, vel vestibulum mi odio tincidunt nisi. Aliquam in pretium mi. Maecenas varius, augue id fermentum accumsan, sem justo vestibulum enim, et laoreet mauris tellus vitae massa. In eget elit massa. In dictum, diam sit amet tincidunt blandit, lacus nulla vestibulum tellus, nec porta enim enim finibus dolor. Aliquam blandit rutrum efficitur. Integer nisi ligula, pretium quis consectetur eu, accumsan nec enim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque porta bibendum ultrices. Duis tristique eu enim sit amet elementum. Quisque vel porttitor sapien.
#
#Integer vitae neque sed nisl consequat molestie a id libero. Etiam in mi bibendum, blandit orci sed, commodo dui. Sed fringilla ac lectus sed feugiat. Etiam nec dolor tellus. Integer hendrerit arcu vel erat pellentesque, ac condimentum quam viverra. Sed lectus purus, feugiat ut urna a, facilisis dapibus sapien. Curabitur posuere ultrices dolor, porttitor interdum turpis laoreet consequat. Vestibulum pulvinar ipsum eros, et placerat purus sodales eget. Suspendisse pharetra ultrices lacinia. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus faucibus arcu metus, ut dapibus lacus blandit in. Vivamus id feugiat velit.
#
#Ut ut risus tincidunt, vestibulum justo sed, lobortis nisl. Duis semper auctor ipsum congue elementum. Nunc faucibus, nibh eu ultricies maximus, quam dolor posuere lacus, quis aliquet justo risus ut sem. Aenean mollis eget diam et fermentum. Fusce vel urna lacus. Proin sodales eros ac urna blandit fringilla. Suspendisse a felis dui. Maecenas efficitur euismod urna, eu ornare odio vulputate eget. Nullam dapibus pharetra dui, in accumsan urna dapibus id. Donec ac ipsum auctor, mollis enim at, viverra eros. Nam semper vestibulum magna sit amet placerat. Donec quis neque at risus vestibulum vehicula sit amet at quam. Nam eget leo massa. Nunc euismod pretium libero, vel imperdiet urna imperdiet ut.
#
#Cras urna erat, commodo at neque non, volutpat mattis nunc. Aenean non finibus nisi. Cras laoreet magna eget vulputate vulputate. Cras accumsan quis nisi ut finibus. Donec placerat ipsum odio, non faucibus ipsum bibendum vel. Morbi iaculis ipsum non sagittis mollis. Morbi id justo suscipit, facilisis tellus non, dignissim nulla. In consequat ullamcorper dictum. Fusce in facilisis purus. Donec erat metus, venenatis ut mi ac, volutpat rutrum lectus. Aliquam ac metus velit. Aliquam at interdum elit, vitae eleifend sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
#
#Ut non tellus vitae velit accumsan congue vitae et tortor. In cursus pellentesque dui quis aliquam. Fusce bibendum elementum sapien facilisis tempor. Morbi efficitur orci a lacinia congue. Quisque bibendum interdum arcu quis sodales. Vestibulum ac tellus vel magna pharetra auctor quis eu metus. Vivamus sed metus facilisis, lobortis nibh nec, hendrerit libero. Nulla facilisi. Duis facilisis vehicula ullamcorper. Duis sit amet malesuada justo. Proin feugiat nibh odio. Pellentesque fermentum vestibulum vehicula. Aliquam dictum tortor vel mi lobortis scelerisque."
#p hex_to_ascii(ciphertext)
#p score_bytes(hex_to_bytes(ciphertext))
#p plaintext
#p score_bytes(ascii_to_bytes(plaintext))
