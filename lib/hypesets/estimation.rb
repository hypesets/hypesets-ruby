module Hypesets
  class Estimation
    attr_reader :set_name, :cardinality

    def initialize(set_name, cardinality)
      @set_name = set_name
      @cardinality = cardinality
    end

    def ==(other)
      @set_name == other.set_name && @cardinality == other.cardinality
    end
  end
end
