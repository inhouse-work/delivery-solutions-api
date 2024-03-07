# frozen_string_literal: true

module DeliverySolutions
  class MergeFixture
    def self.call(...)
      new(...).call
    end

    def initialize(payload:, method_name:, status:)
      @payload = payload
      @method_name = method_name
      @status = status
    end

    def call
      case @payload
      when Hash
        merge(@payload)
      when Array
        return @payload if @payload.empty?

        merge(@payload.first)
      else raise ArgumentError, "Unsupported payload type #{@payload.class}"
      end
    end

    private

    def merge(payload)
      return payload if payload.key?(:errors)

      case fixture
      when Array
        [fixture.first.merge(payload)]
      when Hash
        fixture.merge(payload)
      else raise ArgumentError, "Unsupported fixture type"
      end
    end

    def fixture
      @fixture ||= Fixtures[fixture_path]
    end

    def fixture_path
      Fixtures.find_path_for_method(@method_name, @status)
    end
  end
end
