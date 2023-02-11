defmodule ExCommerce.Factory do
  use ExMachina.Ecto, repo: ExCommerce.Repo

  def site_factory do
    %ExCommerce.Hosting.Site{
      name: "My Site",
      subdomain: sequence(:subdomain, &"site-#{&1}")
    }
  end

  def asset_factory do
    %ExCommerce.Resources.Asset{
      site: build(:site),
      key: sequence(:key, &"/my/asset-#{&1}"),
      content: "Hello World"
    }
  end

  def route_factory do
    %ExCommerce.Hosting.Route{
      site: build(:site),
      path: "/"
    }
  end
end
