defmodule UnderscorecoreWeb.EditCoreAlbumsLive do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  alias Underscorecore.App

  def render(assigns) do
    Phoenix.View.render(UnderscorecoreWeb.CoreView, "edit_core_albums.html", assigns)
  end

  def mount(_params, %{"core_id" => core_id, "current_user" => current_user}, socket) do
    core = App.get_core!(core_id)
    {:ok, assign(socket, %{core: core, current_user: current_user})}
  end

  def handle_event("delete", %{"album_id" => album_id}, socket) do
    core_id = socket.assigns.core.id
    App.delete_core_album!(core_id, album_id)
    core = App.get_core!(core_id)
    {:noreply, assign(socket, :core, core)}
  end
end
