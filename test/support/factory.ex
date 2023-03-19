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

  def product_factory do
    %HandleCommerce.Catalog.Product{
      site: build(:site),
      name: "My Product",
      price: Decimal.new("1000.00"),
      sku: sequence(:sku, &"sku-#{&1}")
    }
  end

  def route_factory do
    %HandleCommerce.Hosting.Route{
      site: build(:site),
      path: sequence(:path, &"/#{&1}")
    }
  end
end
