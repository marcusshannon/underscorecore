defmodule UnderscorecoreWeb.UserRegistrationController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.App
  alias Underscorecore.Models.User
  alias UnderscorecoreWeb.UserAuth

  def new(conn, _params) do
    changeset = App.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case App.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          App.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "Account created successfully. Please confirm account to log in.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        error_map = UnderscorecoreWeb.ErrorHelpers.error_map(changeset)
        render(conn, "new.html", changeset: changeset, error_map: error_map)
    end
  end
end
