# frozen_string_literal: true

module DeliverySolutionsAPI
  module Fixtures
    module_function

    PATHS = {
      create_order: {
        success: "order/create_order/201-result",
        failure: "order/create_order/400-result"
      },
      get_order: {
        success: "order/get_order/200-result",
        failure: "order/get_order/400-result"
      },
      list_orders: {
        success: "order/list_orders/200-default-response",
        failure: "order/list_orders/400-failure-response"
      },
      get_order_status: {
        success: "order/get_order_status/200-result",
        failure: "order/get_order_status/400-failure-response"
      },
      edit_order: {
        success: "order/edit_order/200-successful-edit-response",
        failure: "order/edit_order/400-failure-response"
      },
      retry_order: {
        success: "order/retry_order/201-result",
        failure: "order/retry_order/400-failure-response"
      },
      cancel_order: {
        success: "order/cancel_order/200-successfully-cancel-an-order",
        failure: "order/cancel_order/400-provider-does-not-cancel-order"
      },
      get_alternate_locations: {
        success: "order/get_alternate_locations/200-result",
        failure: "order/get_alternate_locations/400-failure-response"
      },
      update_order_status: {
        success: "order/update_order_status/200-result",
        failure: "order/update_order_status/400-failure-response"
      },
      create_location: {
        success: "pickup_location/create_location/201-response-for-required-fields-only-request",
        failure: "pickup_location/create_location/400-failure-response"
      },
      get_location: {
        success: "pickup_location/get_location/200-result",
        failure: "pickup_location/get_location/400-failure-response"
      },
      list_locations: {
        success: "pickup_location/list_locations/200-result",
        failure: "pickup_location/list_locations/400-failure-response"
      },
      get_rates: {
        success: "rates/get_rates/200-rate-call-with-bare-minimum-fields",
        failure: "rates/get_rates/400-result"
      }

    }.freeze

    def [](path, status)
      return {} unless directory_exists?(path)
      return {} unless fixture_exists?(path, status)

      file = File.read(full_path(path, status))
      JSON.parse(file, symbolize_names: true)
    end

    def fixture_exists?(path, status)
      full_path = full_path(path, status)
      return false if full_path.nil?

      File.exist?(full_path)
    end

    def directory_exists?(path)
      directory = GEM_ROOT.join("fixtures", path)

      Dir.exist?(directory)
    end

    def full_path(path, status)
      directory = GEM_ROOT.join("fixtures", path)

      directory.children.find do |fixture|
        file_name = fixture.to_path.split("/").last

        file_name.include?(status.to_s)
      end
    end

    def find_path_for_method(method, status = :success)
      [method, status].reduce(PATHS, :fetch)
    end

    def exists_for_method?(method_name)
      key?(find_path_for_method(method_name))
    end
  end
end
