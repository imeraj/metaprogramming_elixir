defmodule AshRpc.RpcGen.Info do
  use Spark.InfoGenerator, extension: AshRpc.RpcGen.Resource, sections: [:rpc_gen]
end
