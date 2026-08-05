defmodule AshRpc.Posts do
  use Ash.Domain

  resources do
    resource(AshRpc.Posts.Post)
  end
end
