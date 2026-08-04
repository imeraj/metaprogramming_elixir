defmodule Sample.Manifest.RpcGen.Info do
  use Spark.InfoGenerator, extension: Sample.Manifest.RpcGen.Resource, sections: [:rpc_gen]
end
