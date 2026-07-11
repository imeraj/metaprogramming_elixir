defmodule Sample.Validator.Dsl do
  @moduledoc false
  alias Spark.Builder.{Entity, Field, Section}

  defmodule ValidatorField do
    defstruct [
      :name,
      :type,
      :transform,
      :check,
      :__spark_metadata__
    ]
  end

  @field Entity.new(:field, ValidatorField,
           describe: "A field that is accepted by the validator",
           args: [:name, :type],
           schema: [
             Field.new(:name, :atom, required: true, doc: "The name of the field"),
             Field.new(:type, {:one_of, [:integer, :string]},
               required: true,
               doc: "The type of the field"
             ),
             Field.new(:check, {:fun, 1},
               doc:
                 "A function that can be used to check if the value is valid after type validation."
             ),
             Field.new(:transform, {:fun, 1},
               doc:
                 "A function that will be used to transform the value after successful validation"
             )
           ]
         )
         |> Entity.build!()

  @fields Section.new(:fields,
            describe: "Configure the fields that are supported and required",
            schema: [
              Field.new(:required, {:list, :atom},
                doc: "The fields that must be provided for validation to succeed"
              )
            ],
            entities: [@field]
          )
          |> Section.build!()

  use Spark.Dsl.Extension,
    sections: [@fields],
    transformers: [
      Sample.Validator.Transformers.AddId,
      Sample.Validator.Transformers.GenerateValidate
    ],
    persisters: [Sample.Validator.Persisters.CacheFieldNames],
    verifiers: [Sample.Validator.Verifiers.VerifyRequired]
end
