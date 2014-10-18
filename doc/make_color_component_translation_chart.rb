# Displays the conversion of a color component from 5 bits to 8 bits.
print "\n5-bit to 8-bit color component conversion\n\n"
puts "  5-bit    |     8-bit        "
puts "dec  bin   |   bin     dec hex"
puts "-" * 30
0.upto(31).each do |n|
  n_s = n.to_s.rjust(2, " ")
  b5 = n.to_s(2).rjust(5, '0')
  n2 = (n << 3) | (n >> 2)
  b8 = n2.to_s(2).rjust(8, '0')
  n2_s = n2.to_s.rjust(3, " ")
  n2_s_hex = n2.to_s(16).rjust(2, '0')
  print " #{n_s} #{b5}  |  #{b8} #{n2_s}  #{n2_s_hex}\n"
end
puts ""
