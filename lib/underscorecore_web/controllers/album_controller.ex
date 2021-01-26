defmodule UnderscorecoreWeb.AlbumController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.App

  def index(conn, _params) do
    albums = App.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def show(conn, %{"id" => id}) do
    album = App.get_album!(id)
    render(conn, "show.html", album: album)
  end
end
