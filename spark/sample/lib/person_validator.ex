defmodule Sample.PersonValidator do
  use Sample.Validator

  fields do
    required([:id, :name])
    field(:name, :string)

    field :email, :string do
      check(&String.contains?(&1, "@"))
      transform(&String.trim/1)
    end
  end
end
