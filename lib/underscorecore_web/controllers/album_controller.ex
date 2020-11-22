defmodule UnderscorecoreWeb.AlbumController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.Music

  def index(conn, _params) do
    albums = Music.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def show(conn, %{"id" => id}) do
    album = Music.get_album!(id)
    cores_with_album = Underscorecore.Cores.cores_with_album(album.id)
    render(conn, "show.html", album: album, cores_with_album: cores_with_album)
  end
end
