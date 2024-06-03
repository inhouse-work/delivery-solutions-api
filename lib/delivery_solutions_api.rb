# frozen_string_literal: true

require "zeitwerk"
require "dry/inflector"
require "hashie"
require "json"
require "debug"

require_relative "delivery_solutions_api/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = DeliverySolutionsAPI::Inflector.new(__FILE__)
loader.inflector.inflect(
  "json" => "JSON"
)
loader.setup

module DeliverySolutionsAPI
  module_function

  Session = Data.define(:api_key, :tenant_id)

  GEM_ROOT = Pathname.new(__dir__).join("../").freeze
  public_constant :GEM_ROOT

  def new(...)
    Client.build(...)
  end

  def build_session(api_key:, tenant_id:)
    Session.new(api_key:, tenant_id:)
  end
end
