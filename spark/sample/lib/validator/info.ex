defmodule Sample.Validator.Info do
  use Spark.InfoGenerator, extension: Sample.Validator.Dsl, sections: [:fields]
end
