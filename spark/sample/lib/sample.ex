defmodule Sample do
  @moduledoc false

  def run do
    Sample.PersonValidator.validate(%{id: "1", name: "Meraj", email: "meraj.enigma@gmail.com"})
    |> IO.inspect()

    Sample.PersonValidator.validate(%{id: "2", name: "Meraj", email: "meraj.enigma"})
    |> IO.inspect()

    :ok
  end
end
