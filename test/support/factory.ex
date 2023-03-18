defmodule HandleCommerce.Factory do
  use ExMachina.Ecto, repo: HandleCommerce.Repo

  def site_factory do
    %HandleCommerce.Hosting.Site{
      name: "My Site",
      subdomain: sequence(:subdomain, &"site-#{&1}")
    }
  end

  def asset_factory do
    %HandleCommerce.Resources.Asset{
      site: build(:site),
      key: sequence(:key, &"/my/asset-#{&1}"),
      content: "Hello World"
    }
  end

  def route_factory do
    %HandleCommerce.Hosting.Route{
      site: build(:site),
      path: "/"
    }
  end
end
