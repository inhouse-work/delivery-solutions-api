# frozen_string_literal: true

module DeliverySolutionsAPI
  class Client
    def initialize(raise_api_errors: false)
      @raise_api_errors = raise_api_errors
    end

    def get_rates(params)
      raise NotImplementedError
    end

    def create_order(params)
      raise NotImplementedError
    end

    def update_order_status(params)
      raise NotImplementedError
    end

    def get_order(params)
      raise NotImplementedError
    end

    def get_order_status(params)
      raise NotImplementedError
    end

    def edit_order(params)
      raise NotImplementedError
    end

    def retry_order(params)
      raise NotImplementedError
    end

    def cancel_order(params)
      raise NotImplementedError
    end

    def list_orders
      raise NotImplementedError
    end

    def get_alternate_locations(params)
      raise NotImplementedError
    end

    def list_locations
      raise NotImplementedError
    end

    def create_location(params)
      raise NotImplementedError
    end

    def get_location(params)
      raise NotImplementedError
    end
  end
end
