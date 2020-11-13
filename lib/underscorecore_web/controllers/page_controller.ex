defmodule UnderscorecoreWeb.PageController do
  use UnderscorecoreWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/cores")
  end
end
