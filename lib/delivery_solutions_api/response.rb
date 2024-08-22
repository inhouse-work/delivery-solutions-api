# frozen_string_literal: true

module DeliverySolutionsAPI
  class Response
    ERROR_CODES = [
      500,
      400,
      404,
      409
    ].freeze

    def self.parse(payload:, status:, params: nil)
      payload = case payload
                when String then JSON.parse(payload, symbolize_names: true)
                when Hash then payload
                when Array then { collection: payload }
      end

      # NOTE: Handling case where payload is a String Array that got parsed
      payload = { collection: payload } if payload.is_a?(Array)

      new(payload:, status:, params:)
    end

    attr_reader :payload, :status, :params

    def initialize(status:, payload:, params: nil)
      @payload = Payload.new(payload)
      @status = status
      @params = params
    end

    def error?
      ERROR_CODES.include?(@status)
    end

    def success?
      !error?
    end
  end
end
