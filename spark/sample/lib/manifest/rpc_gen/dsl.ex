defmodule Sample.Manifest.RpcGen.Dsl do
  @moduledoc false

  alias Spark.Builder.{Entity, Field, Section}

  defmodule Method do
    defstruct [
      :action,
      :wire_name,
      :__spark_metadata__
    ]
  end

  @method Entity.new(:method, Method,
            describe: "Configure an RPC generated from an Ash action.",
            args: [:action],
            schema: [
              Field.new(:action, :atom,
                required: true,
                doc: "The Ash action to generate an RPC for."
              ),
              Field.new(:wire_name, :string,
                required: true,
                doc: "The RPC method name exposed on the wire."
              )
            ]
          )
          |> Entity.build!()

  @rpc_gen Section.new(:rpc_gen,
             describe: "Configure RPC generation.",
             entities: [@method]
           )
           |> Section.build!()

  def rpc_gen, do: @rpc_gen
end
