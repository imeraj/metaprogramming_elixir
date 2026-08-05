defmodule AshRpc.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_rpc,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: Mix.env() != :dev
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:ash, "~> 3.0"},
      {:igniter, "~> 0.6", only: [:dev, :test]}
    ]
  end
end
