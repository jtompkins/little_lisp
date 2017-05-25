describe LittleLisp::Parser do
  describe '::tokenize' do
    let(:simple_string) { 'a string' }
    let(:string_with_tokens) { '(lambda (1 2))' }

    it 'returns an array' do
      expect(LittleLisp::Parser.tokenize(simple_string)).to be_an(Array)
    end

    it 'splits the input on spaces' do
      expect(LittleLisp::Parser.tokenize(simple_string).count).to eq(2)
    end

    it 'strips trailing whitespace' do
      result = LittleLisp::Parser.tokenize(simple_string + ' ')

      expect(result[1]).to eq('string')
    end

    it 'separates tokens' do
      expect(LittleLisp::Parser.tokenize(string_with_tokens).count).to eq(7)
    end
  end

  describe '::categorize' do
    context 'when the input is a string' do
      let(:input) { '"string"' }

      it 'returns a literal token' do
        expect(LittleLisp::Parser.categorize(input).type).to eq(:literal)
      end

      it 'returns a token with the string value' do
        expect(LittleLisp::Parser.categorize(input).value).to eq('string')
      end
    end

    context 'when the input is an integer' do
      let(:input) { '1' }

      it 'returns a literal token' do
        expect(LittleLisp::Parser.categorize(input).type).to eq(:literal)
      end

      it 'returns a token with the integer value' do
        expect(LittleLisp::Parser.categorize(input).value).to eq(1)
      end
    end

    context 'when the input is an identifier' do
      let(:input) { 'identifier' }

      it 'returns an identifier token' do
        expect(LittleLisp::Parser.categorize(input).type).to eq(:identifier)
      end

      it 'returns a token with the identifier value' do
        expect(LittleLisp::Parser.categorize(input).value).to eq('identifier')
      end
    end
  end

  describe '::parse' do
    context 'when the input is an empty string' do
      let(:input) { '' }

      it 'returns nil' do
        expect(LittleLisp::Parser.parse(input)).to be_nil
      end
    end

    context 'when the input contains tokens' do
      context 'when the input is a single atom' do
        let(:input) { '1' }

        it 'returns a Token' do
          expect(LittleLisp::Parser.parse(input)).to be_a(LittleLisp::Token)
        end

        it 'returns the atom as a categorized token' do
          expect(LittleLisp::Parser.parse(input).type).to eq(:literal)
        end
      end

      context 'when the input contains multiple atoms' do
        let(:input) { '(1 2)' }

        it 'returns an array containing the atoms' do
          expect(LittleLisp::Parser.parse(input).count).to eq(2)
        end

        it 'categorizes the atoms' do
          expect(LittleLisp::Parser.parse(input).all? { |t| t.type == :literal }).to eq(true)
        end
      end

      context 'when the input includes embedded lists' do
        let(:input) { '(add (1 2))' }

        it 'returns an array containing the atoms and the embedded list' do
          expect(LittleLisp::Parser.parse(input).count).to eq(2)
        end

        it 'categorizes the embedded atoms' do
          result = LittleLisp::Parser.parse(input)

          expect(result[0].type).to eq(:identifier)
          expect(result[1]).to be_an(Array)
          expect(result[1].all? { |t| t.type == :literal }).to eq(true)
        end
      end
    end
  end
end
