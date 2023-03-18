defmodule HandleCommerce.Hosting.Router do
  alias HandleCommerce.Hosting
  alias HandleCommerce.Hosting.{Route, Site, Route}

  @spec get_route(Site.t(), list(String.t())) :: {Route.t(), map} | nil
  def get_route(%Site{} = site, path) do
    {_, routes} =
      Cachex.fetch(:handle_commerce_cache, key(site), fn _key ->
        {:commit,
         site
         |> Hosting.list_routes()
         |> Route.with_segments()}
      end)

    Enum.find_value(routes, fn route ->
      case Route.match(route, path) do
        {:ok, parameters} -> {route, parameters}
        _ -> nil
      end
    end)
  end

  def reset_for(%Site{} = site), do: Cachex.del(:handle_commerce_cache, key(site))
  def reset_for(%Route{} = route), do: Cachex.del(:handle_commerce_cache, key(route))

  defp key(%Site{id: site_id}), do: key(site_id)
  defp key(%Route{site_id: site_id}), do: key(site_id)
  defp key(site_id), do: "site-#{site_id}-routes"
end
