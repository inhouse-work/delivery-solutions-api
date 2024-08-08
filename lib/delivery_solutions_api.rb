# frozen_string_literal: true

require "zeitwerk"
require "dry/inflector"
require "hashie"
require "json"
require "httpx"

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

  def build_session(api_key:, tenant_id:)
    Session.new(api_key:, tenant_id:)
  end

  def test_client
    Client.new
  end

  def sandbox_client
    LiveClient.build(sandbox: true)
  end

  def production_client
    LiveClient.build(sandbox: false)
  end

  def stubbed_response(path, status_code: 200)
    fixture = fixture(path, status_code:)

    Response.parse(payload: fixture, status: status_code)
  end

  def fixture(path, status_code: 200)
    Fixtures[path, status_code]
  end
end
