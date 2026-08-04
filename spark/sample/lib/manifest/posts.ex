defmodule Sample.Manifest.Posts do
  use Ash.Domain

  resources do
    resource(Sample.Manifest.Post)
  end
end
