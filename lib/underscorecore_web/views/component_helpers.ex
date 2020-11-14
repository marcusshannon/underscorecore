defmodule UnderscorecoreWeb.ComponentHelpers do
  def component(template) do
    UnderscorecoreWeb.ComponentView.render(template, [])
  end

  def component(template, [do: children] = assigns) do
    UnderscorecoreWeb.ComponentView.render(template, assigns |> Keyword.drop([:do]) |> Keyword.put(:children, children))
  end

  def component(template, assigns) do
    UnderscorecoreWeb.ComponentView.render(template, assigns)
  end

  def component(template, assigns, do: children) do
    UnderscorecoreWeb.ComponentView.render(template, Keyword.put(assigns, :children, children))
  end

end
