defmodule HandleCommerceWeb.Plugs.HostedRouter do
  @moduledoc """
  Determines which router to use based on the domain
  """

  @behaviour Plug
  import Plug.Conn

  require Logger

  alias HandleCommerce.Hosting
  alias HandleCommerce.Hosting.Site

  @doc false
  def init(default), do: default

  @doc false
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(%Plug.Conn{host: host} = conn, [router: router, env: _] = _opts) do
    Logger.info(fn -> "HandleCommerce Router: host - #{host}" end)

    with split_host <- String.split(host, ".", parts: 2),
         {:ok, domain_alias} <- hosted_site(split_host),
         {:ok, %Site{} = site} <- get_site(domain_alias) do
      Logger.info(fn -> "HandleCommerce Router: Site found #{domain_alias}" end)

      conn
      |> assign(:current_site, site)
      |> router.call(router.init([]))
      |> halt()
    else
      _ -> conn
    end
  end

  @spec hosted_site([String.t()]) :: {:ok, String.t()} | :not_hosted
  defp hosted_site(["www", _]), do: :not_hosted
  defp hosted_site([subdomain, _]), do: {:ok, subdomain}

  defp hosted_site(["localhost"]), do: :not_hosted
  defp hosted_site(domain), do: {:ok, Enum.join(domain, ".")}

  @spec get_site(String.t()) :: {:ok, Site.t()} | {:error, :not_found}
  defp get_site(domain_alias) do
    domain_alias
    |> Hosting.get_site_by_domain()
    |> case do
      nil -> {:error, :not_found}
      site -> {:ok, site}
    end
  end
end
