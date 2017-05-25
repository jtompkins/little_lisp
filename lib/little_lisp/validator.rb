module LittleLisp
  class Validator
    def self.number?(input)
      /^-?[0-9]+$/.match?(input)
    end

    def self.string?(input)
      input[0] == '"' && input[-1] == '"'
    end
  end
end
