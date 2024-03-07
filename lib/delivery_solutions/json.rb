# frozen_string_literal: true

module DeliverySolutions
  module JSON
    module_function

    def parse(*, **)
      ::JSON.parse(*, symbolize_names: true, **)
    end
  end
end
