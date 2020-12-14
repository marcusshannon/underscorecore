defmodule UnderscorecoreWeb.EditCoreAlbumsLive do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(UnderscorecoreWeb.CoreView, "edit_core_albums.html", assigns)
  end

  def mount(_params, %{"core_id" => core_id, "current_user" => current_user}, socket) do
    IO.inspect(socket)
    core = Underscorecore.Cores.get_core!(core_id)
    core_albums = Underscorecore.Cores.get_core_albums(core_id)
    {:ok, assign(socket, %{core: core, core_albums: core_albums, current_user: current_user})}
  end

  def handle_event("delete", %{"album_id" => album_id}, socket) do
    core_id = socket.assigns.core.id
    Underscorecore.Cores.delete_core_album("#{core_id}", album_id)
    core_albums = Underscorecore.Cores.get_core_albums(core_id)
    {:noreply, assign(socket, :core_albums, core_albums)}
  end
end
