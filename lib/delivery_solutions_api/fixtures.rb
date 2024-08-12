# frozen_string_literal: true

module DeliverySolutionsAPI
  module Fixtures
    module_function

    def [](path, status)
      path = Pathname.new("fixtures").join(path)
      raise ArgumentError, "Fixture does not exist" unless path.directory?

      match = path
        .children
        .find { |child| child.basename.to_s.match?(/^#{status}-.*\.json\z/) }

      raise ArgumentError, "Fixture does not exist" unless match

      JSON.parse(match.read, symbolize_names: true)
    end
  end
end
