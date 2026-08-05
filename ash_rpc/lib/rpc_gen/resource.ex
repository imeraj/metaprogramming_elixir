defmodule AshRpc.RpcGen.Resource do
  use Spark.Dsl.Extension,
    sections: [AshRpc.RpcGen.Dsl.rpc_gen()]
end
