# frozen_string_literal: true

module DeliverySolutionsAPI
  module Clients
    class Test < Client
      def self.build(raise_api_errors:)
        new(raise_api_errors:)
      end

      def initialize(raise_api_errors: true)
        @raise_api_errors = raise_api_errors
      end

      def get_rates(status:, **)
        fixture = get_fixture(path: "rates/get_rates", status:)
        merge_fixture(fixture, **)
      end

      def list_locations(status:, **)
        fixture = get_fixture(path: "pickup_location/list_locations", status:)
        merge_fixture(fixture, **)
      end

      def create_order(status:, **)
        fixture = get_fixture(path: "order/create_order", status:)
        merge_fixture(fixture, **)
      end

      def cancel_order(status:, **)
        fixture = get_fixture(path: "order/cancel_order", status:)
        merge_fixture(fixture, **)
      end

      def create_location(status:, **)
        fixture = get_fixture(path: "pickup_location/create_location", status:)
        merge_fixture(fixture, **)
      end

      private

      def get_fixture(path:, status:)
        Fixtures[path, status]
      end

      def merge_fixture(fixture, **)
        return fixture if fixture.is_a?(Array)

        case
        when fixture.keys.size > 1
          return fixture.merge(**)
        when fixture[fixture.keys.first].is_a?(Array)
          return fixture
        end

        fixture
      end
    end
  end
end
