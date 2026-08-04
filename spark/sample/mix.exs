defmodule Sample.MixProject do
  use Mix.Project

  def project do
    [
      app: :sample,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      consolidate_protocols: Mix.env() != :dev
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      compile: ["rpc_gen.schema", "compile"],
      "rpc_gen.schema": "run -e 'Sample.Manifest.RpcGen.Schema.generate_json()'"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sourceror, "~> 1.7", only: [:dev, :test], override: true},
      {:ash, "~> 3.0"},
      {:spark, "~> 2.7.2"},
      {:igniter, "~> 0.8.3"}
    ]
  end
end
