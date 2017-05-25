module LittleLisp
  module Interpreter
    LIBRARY = {
      'first' => ->(input) { input[0] },
      'rest' => ->(input) { input[1..-1] },
      'print' => ->(input) do
        puts(input)
        input
      end
    }.freeze

    SPECIAL = {
      'let' => ->(input, context) { lisp_let(input, context) },
      'lambda' => ->(input, context) { lisp_lambda(input, context) },
      'if' => ->(input, context) { lisp_if(input, context) }
    }.freeze

    module_function

    def interpret(input, context = Context.new(LIBRARY))
      if input.is_a?(Array)
        interpret_list(input, context)
      elsif input.type == :identifier
        context.get(input.value)
      else
        input.value
      end
    end

    def special_form?(input)
      input.count.positive? &&
        input[0].respond_to?(:value) &&
        SPECIAL.key?(input[0].value)
    end

    def interpret_list(input, context)
      if special_form?(input)
        SPECIAL[input[0].value].call(input, context)
      else
        list = input.map { |i| interpret(i, context) }

        return list unless list[0].is_a?(Proc)

        list[0].call(*list[1..-1])
      end
    end

    def lisp_let(input, context)
      let_context = input[1].reduce(Context.new({}, context)) do |acc, x|
        acc.tap do |cxt|
          cxt.scope[x[0].value] = interpret(x[1], context)
        end
      end

      interpret(input[2], let_context)
    end

    def lisp_lambda(input, context)
      ->(*args) do
        lambda_scope = input[1].each_with_index.reduce({}) do |acc, (x, i)|
          acc.tap do |scope|
            scope[x.value] = args[i]
          end
        end

        interpret(input[2], Context.new(lambda_scope, context))
      end
    end

    def lisp_if(input, context)
      condition = interpret(input[1], context)

      if condition && condition != 0
        interpret(input[2], context)
      else
        interpret(input[3], context)
      end
    end
  end
end
