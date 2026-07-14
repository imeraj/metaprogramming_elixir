defmodule Sample.Validator.Verifiers.VerifyRequired do
  use Spark.Dsl.Verifier

  def verify(dsl_state) do
    required = Sample.Validator.Info.fields_required!(dsl_state)
    fields = Enum.map(Sample.Validator.Info.fields(dsl_state), & &1.name)

    if Enum.all?(required, &Enum.member?(fields, &1)) do
      :ok
    else
      location =
        Spark.Dsl.Extension.get_opt_anno(dsl_state, [:fields], :required) ||
          Spark.Dsl.Extension.get_section_anno(dsl_state, [:fields])

      {:error,
       Spark.Error.DslError.exception(
         message: "All required fields must be specified in fields",
         path: [:fields, :required],
         module: Spark.Dsl.Verifier.get_persisted(dsl_state, :module),
         location: location
       )}
    end
  end
end
