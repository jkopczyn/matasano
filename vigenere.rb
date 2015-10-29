require './helpers.rb'

key = "ICE"
example_plaintext = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"

def vigenere(plaintext, key)
  key_bytes = utf8_to_bytes(key)
  key_length = key_bytes.length
  plaintext_bytes = utf8_to_bytes(plaintext)
  full_key_bytes = (key_bytes * (1 + plaintext_bytes.length/key_length))[0...plaintext_bytes.length]
  bytes_to_hex(byte_array_xor(plaintext_bytes, full_key_bytes))
end

#v = vigenere(example_plaintext, key)
#puts v
#puts v == "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
