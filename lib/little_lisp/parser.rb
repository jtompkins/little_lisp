Token = Struct.new(:type, :value)

module Parser
  module_function
  
  def parse(input)
    parenthesize(tokenize(input))
  end

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
    if Validator.number?(input)
      Token.new(:literal, Integer(input))
    elsif Validator.string?(input)
      Token.new(:literal, input[1...-1])
    else
      Token.new(:identifier, input)
    end
  end
end
