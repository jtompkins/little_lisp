describe Interpreter do
  describe '::interpret' do
    let(:tokens) { Parser::parse(script) }

    describe 'lists' do
      context 'when the input is an empty list' do
        let(:script) { '()' }

        it 'should return an empty list' do
          expect(Interpreter::interpret(tokens)).to eq([]);
        end
      end

      context 'when the input is a list of strings' do
        let(:script) { '("hi" "mary" "rose")' }

        it 'should return a list of strings' do
          expect(Interpreter::interpret(tokens)).to eq(['hi', 'mary', 'rose'])
        end
      end

      context 'when the input is a list of numbers' do
        let(:script) { '(1 2 3)' }

        it 'should return a list of numbers' do
          expect(Interpreter::interpret(tokens)).to eq([1, 2, 3])
        end
      end

      context 'when the input is a list of numbers as strings' do
        let(:script) { '("1" "2" "3")' }

        it 'should return a list of numbers in strings as strings' do
          expect(Interpreter::interpret(tokens)).to eq(["1", "2", "3"])
        end
      end
    end

    describe 'atoms' do
      context 'when the input is a string atom' do
        let(:script) { '"a"' }

        it 'should return string atom' do
          expect(Interpreter::interpret(tokens)).to eq('a')
        end
      end

      context 'when the input is a string with spaces' do
        let(:script) { '"a b"' }

        it 'should return string with space atom' do
          expect(Interpreter::interpret(tokens)).to eq('a b')
        end
      end

      context 'when the input is a string with only an opening paren' do
        let(:script) { '"(a"' }

        it 'should return string with opening paren' do
          expect(Interpreter::interpret(tokens)).to eq('(a')
        end
      end

      context 'when the input is a string with only a closing paren' do
        let(:script) { '")a"' }

        it 'should return string with closing paren' do
          expect(Interpreter::interpret(tokens)).to eq(')a')
        end
      end

      context 'when the input is a string with paired parens' do
        let(:script) { '"(a)"' }

        it 'should return string with parens' do
          expect(Interpreter::interpret(tokens)).to eq('(a)')
        end
      end

      context 'when the input is a number' do
        let(:script) { '123' }

        it 'should return number atom' do
          expect(Interpreter::interpret(tokens)).to eq(123)
        end
      end
    end

    context 'the standard library' do
      describe '(first)' do
        let(:script) { '(first (99 98))' }

        it 'selects the first item in the input list' do
          expect(Interpreter::interpret(tokens)).to eq(99)
        end
      end

      describe '(rest)' do
        let(:script) { '(rest (99 98 97))' }

        it 'selects all but the head of the input list' do
          expect(Interpreter::interpret(tokens)).to eq([98, 97])
        end
      end

      describe '(print)' do
        let(:script) { '(print 1)' }

        it 'prints the input' do
          expect(STDOUT).to receive(:puts).with(1)

          Interpreter::interpret(tokens)
        end
      end
    end

    context 'special forms' do
      describe '(let)' do
        let(:script) { '(let ((x 1)) x)' }

        it 'binds the names correctly' do
          expect(Interpreter::interpret(tokens)).to eq(1)
        end
      end

      describe '(lambda)' do
        context 'when the lambda takes no args' do
          let(:script) { '((lambda () (rest (1 2))))' }

          it 'returns the correct result' do
            expect(Interpreter::interpret(tokens)).to eq([2])
          end
        end

        context 'when the lamdba takes an arg' do
          let(:script) { '((lambda (x) x) 1)' }

          it 'returns the correct result' do
            expect(Interpreter::interpret(tokens)).to eq(1)
          end
        end

        context 'when the lambda returns a list' do
          let(:script) { '((lambda (x y) (x y)) 1 2)' }

          it 'returns the correct result' do
            expect(Interpreter::interpret(tokens)).to eq([1, 2])
          end
        end
      end

      describe '(if)' do
        context 'when the condition is true' do
          let(:script) { '(if 1 42 4711)' }

          it 'executes the first atom' do
            expect(Interpreter::interpret(tokens)).to eq(42)
          end
        end

        context 'when the condition is false' do
          let(:script) { '(if 0 42 4711)' }

          it 'executes the second atom' do
            expect(Interpreter::interpret(tokens)).to eq(4711)
          end
        end
      end
    end
  end
end
