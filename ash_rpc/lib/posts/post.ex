defmodule AshRpc.Posts.Post do
  use Ash.Resource,
    otp_app: :ash_rpc,
    data_layer: Ash.DataLayer.Ets,
    domain: AshRpc.Posts,
    extensions: [AshRpc.RpcGen.Resource]

  defmodule Status do
    use Ash.Type.Enum,
      values: [
        :draft,
        :published,
        :archived
      ]
  end

  rpc_gen do
    method(:read, wire_name: "posts.list")
    method(:create, wire_name: "posts.create")
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:title, :string, public?: true, allow_nil?: false)
    attribute(:status, Status, public?: true)
  end

  actions do
    actions do
      read :read do
        primary?(true)
      end

      create :create do
        primary?(true)

        accept([
          :title,
          :status
        ])
      end
    end
  end
end
