describe Interpreter do
  describe '::interpret' do
    let(:script) do
      '(print 1)'
    end

    it 'runs a script' do
      Interpreter::interpret(Parser::parse(script))
    end
  end
end
