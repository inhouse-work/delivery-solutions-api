# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Sets up the environment for the tasks"
task :environment do
  require "delivery_solutions_api"
end

desc "Gets rates from the sandbox API"
task get_rates: :environment do
  require "debug"
  require "dotenv/load"
  require "json"

  client = DeliverySolutionsAPI::Client.build(sandbox: true)
  session = DeliverySolutionsAPI.build_session(
    api_key: ENV.fetch("API_KEY"),
    tenant_id: ENV.fetch("TENANT_ID")
  )

  params = {
    deliveryAddress: {
      zipcode: "91367"
    },
    storeExternalIds: [
      "70786023599"
    ]
  }

  client.get_rates(session:, **params).tap do |_result|
    # debugger
  end
end
