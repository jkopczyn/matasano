require 'base64'
require 'byebug'

def hex_to_bytes(string)
  string.scan(/../).map(&:hex)
end

def bytes_to_base64(byte_array)
  partition_bytes(byte_array, 4).pack("Q*")
end

def concat_bytes(byte_array)
  accum = 0
  byte_array.each do |byte|
    accum *= 256
    accum += byte
  end
  accum
end

def partition_bytes(byte_array, chunk_length)
  chunk = []
  output_numbers = []
  byte_array.each do |byte|
    chunk << byte
    if chunk.length >= chunk_length
      output_numbers << concat_bytes(chunk)
      chunk = []
    end
  end
  output_numbers << concat_bytes(chunk) unless chunk.empty?
  output_numbers
end


