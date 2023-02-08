defmodule ExCommerce.Factory do
  use ExMachina.Ecto, repo: ExCommerce.Repo

  def site_factory do
    %ExCommerce.Hosting.Site{
      name: "My Site",
      subdomain: sequence(:subdomain, &"site-#{&1}")
    }
  end
end
