defmodule CreateCoreScript do
  import Ecto.Query, warn: false

  def fetch_collage(collage_id) do
    Finch.build(:get, "https://redacted.ch/ajax.php?action=collage&id=#{collage_id}", [{"Authorization", "33ea1089.f686fdc94559acdde59caa7e9ec4889b"}])
    |> Finch.request(Underscorecore.Finch)
  end

  def get_response_body({:ok, response}) do
      Jason.decode!(response.body)
  end

  def get_torrent_groups_from_body(body) do
    body["response"]["torrentgroups"]
  end

  
  def map_to_search_term(torrent_groups) do
    Enum.map(torrent_groups, fn torrent_group -> 
      album = torrent_group["name"] |> HtmlEntities.decode
      artist = (torrent_group["musicInfo"]["artists"] |> List.first())["name"] |> HtmlEntities.decode
      "#{artist} #{album}"
     end)
  end

  def get_core_name(body) do
    body["response"]["name"] |> HtmlEntities.decode
  end

  def main(collage_id) do
    body = fetch_collage(collage_id)
    |> get_response_body()

    search_terms = body
    |> get_torrent_groups_from_body
    |> map_to_search_term

    core_name = get_core_name(body)
    
    unless Underscorecore.Repo.exists?(from c in "cores", where: c.name == ^core_name) do
      Underscorecore.Repo.insert(%Underscorecore.Cores.Core{name: core_name})
    end

    core = Underscorecore.Repo.get_by!(Underscorecore.Cores.Core, name: core_name)

    Enum.each(search_terms, fn search_term -> 
      Process.sleep(2000)
      try do
        search_results = Underscorecore.Search.search(search_term)
        unless length(search_results) == 0 do
          {artist, album} = List.first search_results
          Underscorecore.Repo.insert(%Underscorecore.Cores.CoreAlbum{album_id: album.id, core_id: core.id}, on_conflict: :nothing)
        end
      rescue
          x -> x
      end
    end)
  end
end

CreateCoreScript.main(System.argv |> List.first)