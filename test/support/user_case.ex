defmodule App.UserCase do
  use ExUnit.CaseTemplate

  setup_all _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.Repo)

    Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :auto)

    user_params =
      %{
        first_name: "John Benedict",
        last_name: "Benin",
        email: "test@email.com",
        username: "jbrb",
        password: "1234"
      }
    {:ok, user} = App.Accounts.create_user(user_params)

    {:ok, auth_map} =
      AppWeb.Services.Authenticator.authorize(user.username, "1234")

    on_exit(fn ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :auto)

      user = App.Accounts.get_user_by_username(user.username)
      App.Accounts.delete_user(user)
      :ok
    end)

  %{auth_map: auth_map, user: user}
  end
end
