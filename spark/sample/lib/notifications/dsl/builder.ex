defmodule Sample.Notifications.Dsl.Builder do
  alias Spark.Builder.{Entity, Field, Section}

  def notification_entity do
    Entity.new(:notification, Sample.Notifications.Notification,
      describe: "Defined a notification delivery",
      args: [:name, :type],
      schema: [
        Field.new(:name, :atom, required: true, doc: "Notification name"),
        Field.new(:type, {:one_of, [:email, :slack]}, required: true, doc: "Notification type"),
        Field.new(:target, :string, doc: "Delivery target"),
        Field.new(:metadata, :keyword_list,
          keys: [
            priority: [type: :integer, default: 0, doc: "Priority level"]
          ],
          doc: "Optional metadata"
        )
      ],
      identifier: :name
    )
    |> Entity.build!()
  end

  def notifications_section do
    Section.new(:notifications,
      describe: "Notification configuration",
      entities: [notification_entity()]
    )
    |> Section.build!()
  end
end
