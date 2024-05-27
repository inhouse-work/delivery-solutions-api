# frozen_string_literal: true

module DeliverySolutionsAPI
  module JSON
    module_function

    def parse(*, **)
      ::JSON.parse(*, symbolize_names: true, **)
    end

    def stringify(*, **)
      ::JSON.generate(*, **)
    end
  end
end
