# frozen_string_literal: true

module DeliverySolutionsAPI
  module Clients
    class Test < Client
      def self.build(raise_api_errors:)
        new(raise_api_errors:)
      end

      def initialize(raise_api_errors: true, status:)
        @raise_api_errors = raise_api_errors
        @status = status
      end

      def get_rates(**)
        fixture = get_fixture(path: "rates/get_rates")
        merge_fixture(fixture, **)
      end

      def list_locations(**)
        fixture = get_fixture(path: "pickup_location/list_locations")
        merge_fixture(fixture, **)
      end

      def create_order(**)
        fixture = get_fixture(path: "order/create_order")
        merge_fixture(fixture, **)
      end

      def cancel_order(**)
        fixture = get_fixture(path: "order/cancel_order")
        merge_fixture(fixture, **)
      end

      def create_location(**)
        fixture = get_fixture(path: "pickup_location/create_location")
        merge_fixture(fixture, **)
      end

      private

      def get_fixture(path:)
        Fixtures[path, @status]
      end

      def merge_fixture(fixture, **)
        return fixture if fixture.is_a?(Array)

        return fixture.merge(**) if fixture.keys.size > 1
        return fixture if fixture.values.first.is_a?(Array)

        fixture
      end
    end
  end
end
