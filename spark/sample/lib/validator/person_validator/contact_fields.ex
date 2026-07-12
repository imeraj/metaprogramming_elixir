defmodule Sample.PersonValidator.ContactFeilds do
  use Spark.Dsl.Fragment, of: Sample.Validator

  fields do
    field :email, :string do
      check(&String.contains?(&1, "@"))
      transform(&String.trim/1)
    end
  end
end
