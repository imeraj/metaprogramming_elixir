ExUnit.start()
Code.require_file("translator.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  defmodule I18n do
    use Translator

    locale("en",
      foo: "bar",
      flash: [
        hello: "Hello %{first} %{last}!",
        bye: "Bye, %{name}!"
      ],
      users: [
        title: "Users"
      ]
    )

    locale("fr",
      flash: [
        hello: "Salut %{first} %{last}!",
        bye: "Ay revoir, %{name}!"
      ],
      users: [
        title: "Utilisateurs"
      ]
    )
  end

  test "it recursively walks translation tree" do
    assert I18n.t("en", "users.title") == "Users"
    assert I18n.t("fr", "users.title") == "Utilisateurs"
  end

  test "it handles translations at root level" do
    assert I18n.t("en", "foo") == "bar"
  end

  test "it allows multiple locales to be registered" do
    assert I18n.t("fr", "flash.hello", first: "Meraj", last: "Molla") == "Salut Meraj Molla!"
  end

  test "t/3 raises KeyError when bindings not provided" do
    assert_raise KeyError, fn -> I18n.t("en", "flash.hello") end
  end

  test "t/3 returns {:error, :no_translation} when translation is missing" do
    assert I18n.t("en", "flash.not_exists") == {:error, :no_translations}
  end

  test "converts interpolation values to string " do
    assert I18n.t("fr", "flash.hello", first: 123, last: 345) == "Salut 123 345!"
  end
end
