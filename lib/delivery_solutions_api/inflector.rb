module DeliverySolutionsAPI
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, abspath)
      if basename =~ /\Adelivery_solutions_api(.*)/
        "DeliverySolutionsAPI#{super(Regexp.last_match(1), abspath)}"
      else
        super
      end
    end
  end
end
