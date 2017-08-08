def caesar_cipher(string, value)
  i = 0
  while i < string.length
    index = string[i].ord
    if index.between?('a'.ord,'z'.ord)
      string[i] =  (((index + value - 'a'.ord) % 26) + 'a'.ord).chr
    elsif index.between?('A'.ord,'Z'.ord)
      string[i] =  (((index + value - 'A'.ord) % 26) + 'A'.ord).chr
    end
    i += 1
  end

  string
end
