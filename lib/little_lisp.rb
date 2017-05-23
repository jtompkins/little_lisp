Token = Struct.new(:type, :value)

def tokenize(input)
  input
    .gsub(/\(/, ' ( ')
    .gsub(/\)/, ' ) ')
    .split(' ')
end

def parenthesize(input, list = [])
  token = input.shift

  case token
  when nil
    return list.pop
  when '('
    list.push(parenthesize(input))
    return parenthesize(input, list)
  when ')'
    return list
  else
    return parenthesize(input, list.push(categorize(token)))
  end
end

def categorize(input)
  if number?(input)
    Token.new(:literal, Integer(input))  
  elsif string?(input)
    Token.new(:literal, input[1...-1])
  else
    Token.new(:identifier, input)
  end
end

def number?(input)
  /^-?[0-9]+$/.match?(input)
end

def string?(input)
  input[0] == '"' && input[-1] == '"'
end
