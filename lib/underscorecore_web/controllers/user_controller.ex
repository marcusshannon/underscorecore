defmodule UnderscorecoreWeb.UserController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.App

  def show(conn, %{"id" => id}) do
    user = App.get_user!(id)
    render(conn, "show.html", user: user)
  end
end
