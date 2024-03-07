# frozen_string_literal: true

module DeliverySolutions
  module Errors
    module_function

    def localized(type)
      inflector = Dry::Inflector.new
      inflector.constantize(
        inflector.camelize("delivery_solutions/errors/#{type.downcase}")
      )
    rescue NameError => e
      Error.new(e.message)
    end

    Error = Class.new(StandardError)
    public_constant :Error

    class InvalidData < Error; end
    class CancellationNotAllowed < Error; end
    class DuplicateId < Error; end
    class DuplicateName < Error; end
    class DuplicateResource < Error; end
    class EntityIsNotActive < Error; end
    class Forbidden < Error; end
    class GeocodingFailed < Error; end
    class InternalServerError < Error; end
    class InvalidOperation < Error; end
    class NoDspAssigned < Error; end
    class NoDspMatched < Error; end
    class NotFound < Error; end
    class OrderAlreadyCancelled < Error; end
    class OrderCancellationFailed < Error; end
    class PlaceOrderFailed < Error; end
    class TooManyRequests < Error; end
    class Unauthorized < Error; end
    class UnmappedError < Error; end
    class ValidationError < Error; end
    class ScoringFailed < Error; end
  end
end
