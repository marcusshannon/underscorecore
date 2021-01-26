defmodule UnderscorecoreWeb.PageController do
  use UnderscorecoreWeb, :controller
  alias Underscorecore.App

  def index(conn, _params) do
    cores = App.get_cores()

    render(conn, "index.html", cores: cores)
  end
end
