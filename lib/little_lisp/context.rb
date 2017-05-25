module LittleLisp
  class Context
    def initialize(scope, parent = nil)
      @scope = scope
      @parent = parent
    end

    attr_reader :scope, :parent

    def get(identifier)
      if scope.key?(identifier)
        scope[identifier]
      else
        parent.get(identifier)
      end
    end
  end
end
