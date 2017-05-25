describe LittleLisp::Validator do
  describe '.number?' do
    let(:valid_integer) { '1' }
    let(:invalid_integer) { 'test' }
    let(:negative_integer) { '-1' }

    context 'when the input is a valid integer' do
      it 'returns true' do
        expect(LittleLisp::Validator.number?(valid_integer)).to eq(true)
      end

      it 'handles negative integers' do
        expect(LittleLisp::Validator.number?(negative_integer)).to eq(true)
      end
    end

    context 'when the input is not a valid integer' do
      it 'returns false' do
        expect(LittleLisp::Validator.number?(invalid_integer)).to eq(false)
      end
    end
  end

  describe '.string?' do
    let(:valid_string) { '"valid string"' }
    let(:invalid_string) { 'invalid string' }

    context 'when the input is wrapped in double quotes' do
      it 'returns true' do
        expect(LittleLisp::Validator.string?(valid_string)).to eq(true)
      end
    end

    context 'when the input is not wrapped in double quotes' do
      it 'returns false' do
        expect(LittleLisp::Validator.string?(invalid_string)).to eq(false)
      end
    end
  end
end
