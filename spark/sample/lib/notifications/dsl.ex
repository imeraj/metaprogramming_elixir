defmodule Sample.Notifications.Dsl do
  alias Sample.Notifications.Dsl.Builder

  use Spark.Dsl.Extension, sections: [Builder.notifications_section()]
  use Spark.Dsl, default_extensions: [extensions: __MODULE__]
end
