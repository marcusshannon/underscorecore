defmodule UnderscorecoreWeb.PageController do
  use UnderscorecoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", error_message: nil)
  end
end
