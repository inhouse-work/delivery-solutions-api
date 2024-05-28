# frozen_string_literal: true

module DeliverySolutionsAPI
  module Clients
    class Test < Client
      NoStubError = Class.new(NoMethodError)

      attr_reader :stubs

      def initialize(raise_api_errors: true)
        @raise_api_errors = raise_api_errors
        @stubs = {}
      end

      def create_order(...)
        stubbed_response(:create_order, ...)
      end

      def get_rates(...)
        stubbed_response(:get_rates, ...)
      end

      def get_order(...)
        stubbed_response(:get_order, ...)
      end

      def list_locations(...)
        stubbed_response(:list_locations, ...)
      end

      def get_alternate_locations(...)
        stubbed_response(:get_alternate_locations, ...)
      end

      def get_location(...)
        stubbed_response(:get_location, ...)
      end

      def get_order_status(...)
        stubbed_response(:get_order_status, ...)
      end

      def update_order_status(...)
        stubbed_response(:update_order_status, ...)
      end

      def list_orders(...)
        stubbed_response(:list_orders, ...)
      end

      def retry_order(...)
        stubbed_response(:retry_order, ...)
      end

      def edit_order(...)
        stubbed_response(:edit_order, ...)
      end

      def cancel_order(...)
        stubbed_response(:cancel_order, ...)
      end

      def create_location(...)
        stubbed_response(:create_location, ...)
      end

      def stub(status = :success, **methods)
        unless %i[success failure].include?(status)
          raise ArgumentError, "Invalid status '#{status}' provided to #stub"
        end

        methods = methods.transform_values do |payload|
          if payload.is_a? String
            payload = JSON.parse(
              payload,
              symbolize_names: true
            )
          end

          payload
        end

        methods.each do |method_name, payload|
          methods[method_name] = MergeFixture.call(
            payload:,
            method_name:,
            status:
          )
        end

        tap do
          @stubs.merge!(methods)
        end
      end

      private

      def stubbed_response(method_name, ...)
        payload = @stubs.fetch(method_name) do
          path = Fixtures.find_path_for_method(method_name)
          Fixtures[path]
        end

        Response.parse(payload).tap do |response|
          next unless @raise_api_errors

          if response.error?
            message = response.payload.message
            # rubocop:disable Style/RaiseArgs
            raise Errors.localized(response.payload.type).new(message)
            # rubocop:enable Style/RaiseArgs
          end
        end
      end
    end
  end
end
