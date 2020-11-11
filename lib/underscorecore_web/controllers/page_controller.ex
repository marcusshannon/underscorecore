defmodule UnderscorecoreWeb.PageController do
  use UnderscorecoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
