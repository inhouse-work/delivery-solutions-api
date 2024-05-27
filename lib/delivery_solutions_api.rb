# frozen_string_literal: true

# $LOAD_PATH.unshift(File.dirname(__FILE__))

require "zeitwerk"
require "dry/inflector"
require "hashie"
require "json"
require "debug"

require_relative "delivery_solutions_api/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = DeliverySolutionsAPI::Inflector.new(__FILE__)
loader.setup

module DeliverySolutionsAPI
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
