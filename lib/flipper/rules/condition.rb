require 'flipper/rules/rule'

module Flipper
  module Rules
    class Condition < Rule
      OPERATIONS = {
        "eq"  => -> (left:, right:, **) { left == right },
        "neq" => -> (left:, right:, **) { left != right },
        "gt"  => -> (left:, right:, **) { left && right && left > right },
        "gte" => -> (left:, right:, **) { left && right && left >= right },
        "lt"  => -> (left:, right:, **) { left && right && left < right },
        "lte" => -> (left:, right:, **) { left && right && left <= right },
        "in"  => -> (left:, right:, **) { left && right && right.include?(left) },
        "nin" => -> (left:, right:, **) { left && right && !right.include?(left) },
        "percentage" => -> (left:, right:, feature_name:) do
          # this is to support up to 3 decimal places in percentages
          scaling_factor = 1_000
          id = "#{feature_name}#{left}"
          left && right && (Zlib.crc32(id) % (100 * scaling_factor) < right * scaling_factor)
        end
      }.freeze

      def self.build(hash)
        new(hash.fetch("left"), hash.fetch("operator"), hash.fetch("right"))
      end

      attr_reader :left, :operator, :right

      def initialize(left, operator, right)
        @left = left
        @operator = operator
        @right = right
      end

      def value
        {
          "type" => "Condition",
          "value" => {
            "left" => @left,
            "operator" => @operator,
            "right" => @right,
          }
        }
      end

      def eql?(other)
        self.class.eql?(other.class) &&
          @left == other.left &&
          @operator == other.operator &&
          @right == other.right
      end
      alias_method :==, :eql?

      def matches?(feature_name, actor = nil)
        properties = actor ? actor.flipper_properties.merge("flipper_id" => actor.flipper_id) : {}.freeze
        left_value = evaluate(@left, properties)
        right_value = evaluate(@right, properties)
        operator_name = @operator.fetch("value")
        operation = OPERATIONS.fetch(operator_name) do
          raise "operator not implemented: #{operator_name}"
        end

        !!operation.call(left: left_value, right: right_value, feature_name: feature_name)
      end

      private

      def evaluate(hash, properties)
        type = hash.fetch("type")

        case type
        when "Property"
          properties[hash.fetch("value")]
        when "Random"
          rand hash.fetch("value")
        when "Array", "String", "Integer", "Boolean"
          hash.fetch("value")
        when "Null"
          nil
        else
          raise "type not found: #{type.inspect}"
        end
      end
    end
  end
end