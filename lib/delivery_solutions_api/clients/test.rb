# frozen_string_literal: true

module DeliverySolutionsAPI
  module Clients
    class Test
      NoStubError = Class.new(NoMethodError)

      attr_reader :stubs

      def initialize(raise_api_errors: true)
        @raise_api_errors = raise_api_errors
        @stubs = {}
      end

      def method_missing(method_name, ...)
        if available_response?(method_name)
          stubbed_response(method_name, ...)
        else
          super
        end
      end

      # rubocop:disable Lint/UnusedMethodArgument
      def respond_to_missing?(method_name, include_private = false)
        @stubs.include?(method_name) || Fixtures.exists_for_method?(method_name)
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def stub(status = :success, **methods)
        unless %i[success failure].include?(status)
          raise ArgumentError, "Invalid status '#{status}' provided to #stub"
        end

        methods = methods.transform_values do |payload|
          payload = JSON.parse(payload) if payload.is_a? String
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

      def raise_stub_not_provided(method_name)
        raise(
          NoStubError,
          "No stub with name #{method_name} was provided to the test client"
        )
      end

      def available_response?(method_name)
        @stubs.include?(method_name) || Fixtures.exists_for_method?(method_name)
      rescue KeyError
        raise_stub_not_provided(method_name)
      end

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
