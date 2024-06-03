# frozen_string_literal: true

module DeliverySolutionsAPI
  class Response
    attr_reader :payload

    ERROR_CODES = [
      500,
      400,
      404
    ].freeze

    def self.parse(payload)
      payload = case payload
                when String then JSON.parse(payload)
                when Hash then payload
                when Array then { collection: payload }
      end

      # NOTE: Handling case where payload is a String Array that got parsed
      payload = { collection: payload } if payload.is_a?(Array)

      new(payload)
    end

    def initialize(payload = {})
      @payload = Payload.new(payload)
    end

    def error?
      return true if ERROR_CODES.include?(payload.statusCode)
      return false if payload.errors.nil?

      payload.errors.any?
    end

    def success?
      !error?
    end
  end
end
