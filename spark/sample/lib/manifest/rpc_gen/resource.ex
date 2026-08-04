defmodule Sample.Manifest.RpcGen.Resource do
  use Spark.Dsl.Extension,
    sections: [Sample.Manifest.RpcGen.Dsl.rpc_gen()]
end
