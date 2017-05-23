describe '#tokenize' do
  let(:simple_string) { 'a string' }
  let(:string_with_tokens) { '(lambda (1 2))' }

  it 'returns an array' do
    expect(tokenize(simple_string)).to be_an(Array)
  end

  it 'splits the input on spaces' do
    expect(tokenize(simple_string).count).to eq(2)
  end

  it 'strips trailing whitespace' do
    result = tokenize(simple_string + ' ')

    expect(result[1]).to eq('string')
  end

  it 'separates tokens' do
    expect(tokenize(string_with_tokens).count).to eq(7)
  end
end

describe '#number?' do
  let(:valid_integer) { "1" }
  let(:invalid_integer) { "test" }
  let(:negative_integer) { "-1" }

  context 'when the input is a valid integer' do
    it 'returns true' do
      expect(number?(valid_integer)).to eq(true)
    end  

    it 'handles negative integers' do
      expect(number?(negative_integer)).to eq(true)    
    end
  end
  
  context 'when the input is not a valid integer' do
    it 'returns false' do
      expect(number?(invalid_integer)).to eq(false)
    end
  end
end

describe '#string?' do
  let(:valid_string) { '"valid string"' }
  let(:invalid_string) { 'invalid string' }

  context 'when the input is wrapped in double quotes' do
    it 'returns true' do
      expect(string?(valid_string)).to eq(true)
    end
  end
  
  context 'when the input is not wrapped in double quotes' do
    it 'returns false' do
      expect(string?(invalid_string)).to eq(false)
    end
  end
end

describe '#categorize' do
  context 'when the input is a string' do
    let(:input) { '"string"' }

    it 'returns a literal token' do
      expect(categorize(input).type).to eq(:literal)
    end

    it 'returns a token with the string value' do
      expect(categorize(input).value).to eq('string')
    end
  end
  
  context 'when the input is an integer' do
    let(:input) { '1' }

    it 'returns a literal token' do
      expect(categorize(input).type).to eq(:literal)
    end

    it 'returns a token with the integer value' do
      expect(categorize(input).value).to eq(1)
    end
  end
  
  context 'when the input is an identifier' do
    let(:input) { 'identifier' }

    it 'returns an identifier token' do
      expect(categorize(input).type).to eq(:identifier)
    end
    
    it 'returns a token with the identifier value' do
      expect(categorize(input).value).to eq('identifier')
    end
  end
end

describe '#parenthesize' do
  context 'when the input is an empty array' do
    let(:input) { [] }

    it 'returns nil' do
      expect(parenthesize(input)).to be_nil
    end
  end
  
  context 'when the input contains tokens' do
    context 'when the input is a single atom' do
      let(:input) { '1' }
      let(:tokens) { tokenize(input) }

      it 'returns a Token' do
        expect(parenthesize(tokens)).to be_a(Token)
      end

      it 'returns the atom as a categorized token' do
        expect(parenthesize(tokens).type).to eq(:literal)
      end  
    end

    context 'when the input contains multiple atoms' do
      let(:input) { '(1 2)' }
      let(:tokens) { tokenize(input) }

      it 'returns an array containing the atoms' do
        expect(parenthesize(tokens).count).to eq(2)
      end

      it 'categorizes the atoms' do
        expect(parenthesize(tokens).all? { |t| t.type == :literal }).to eq(true)
      end
    end
    
    context 'when the input includes embedded lists' do
      let(:input) { '(add (1 2))' }
      let(:tokens) { tokenize(input) }

      it 'returns an array containing the atoms and the embedded list' do
        expect(parenthesize(tokens).count).to eq(2)
      end
      
      it 'categorizes the embedded atoms' do
        result = parenthesize(tokens)

        expect(result[0].type).to eq(:identifier)
        expect(result[1]).to be_an(Array)
        expect(result[1].all? { |t| t.type == :literal}).to eq(true)
      end
    end
  end
end
