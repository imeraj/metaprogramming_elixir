defmodule Sample.Notification do
  use Sample.Notifications.Dsl

  notifications do
    notification :ops, :email do
      target("ops@example.com")
      metadata(priority: 1)
    end
  end
end
