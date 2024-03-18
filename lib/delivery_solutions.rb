# frozen_string_literal: true

require "dry/inflector"
require "hashie"
require "json"
require "debug"

require_relative "delivery_solutions/response"
require_relative "delivery_solutions/fixtures"
require_relative "delivery_solutions/payload"
require_relative "delivery_solutions/errors"
require_relative "delivery_solutions/version"
require_relative "delivery_solutions/json"
require_relative "delivery_solutions/mock_client"
require_relative "delivery_solutions/merge_fixture"
require_relative "delivery_solutions/client"

module DeliverySolutions
  module_function

  GEM_ROOT = Pathname.new(__dir__).join("../").freeze
  public_constant :GEM_ROOT

  def new(test: false, raise_api_errors: true, **)
    if test
      MockClient.new(raise_api_errors:)
    else
      Client.new(**)
    end
  end
end
