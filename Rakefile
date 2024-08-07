# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :environment do
  require "delivery_solutions_api"
end

desc "Gets rates from the sandbox API"
task get_rates: :environment do
  require "debug"
  require "dotenv/load"

  client = DeliverySolutionsAPI::Client.build(sandbox: true)
  session = DeliverySolutionsAPI.build_session(
    api_key: ENV.fetch("API_KEY"),
    tenant_id: ENV.fetch("TENANT_ID")
  )

  params = {
    "deliveryAddress": {
      "country": "US",
      "zipcode": "91367",
      "state": "CA",
      "city": "Woodland Hills",
      "street": "24201 Burbank Blvd"
    },
    "storeExternalIds": [
      "70786023599"
    ]
  }

  result = client.get_rates(session:, **params)

  debugger
end
