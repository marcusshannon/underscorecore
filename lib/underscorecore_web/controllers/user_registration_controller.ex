defmodule UnderscorecoreWeb.UserRegistrationController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.Accounts
  alias Underscorecore.Accounts.User
  alias UnderscorecoreWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        error_map = UnderscorecoreWeb.ErrorHelpers.error_map(changeset)
        render(conn, "new.html", changeset: changeset, error_map: error_map)
    end
  end
end
