defmodule Sample.PersonValidator.BaseFeilds do
  use Spark.Dsl.Fragment, of: Sample.Validator

  fields do
    required([:id, :name])
    field(:name, :string)
    timestamps?(true)
  end
end
