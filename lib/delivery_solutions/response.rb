# frozen_string_literal: true

module DeliverySolutions
  class Response
    attr_reader :payload
    ERROR_CODES = [
      500,
      400,
      404
    ]

    def self.parse(payload)
      payload = case payload
                when String then JSON.parse(payload)
                when Hash then payload
                when Array then { collection: payload }
      end

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
