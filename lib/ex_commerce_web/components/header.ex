defmodule ExCommerceWeb.Header do
  use ExCommerceWeb, :html

  def header(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8 bg-gray-800">
      <div class="flex items-center justify-between py-3">
        <!--- Logo --->
        <div class="flex items-center gap-4 text-red-100">
          <a href="/" class="px-2 text-xl font-semibold leading-6 text-brand">
            ExCommerce
          </a>
        </div>

        <div class="flex items-center gap-4">
          <%= if assigns[:current_user] do %>
            <.header_link href={~p"/users/settings"}><%= @current_user.email %></.header_link>
            <.header_link href={~p"/users/log_out"} method="delete">Log out</.header_link>
          <% else %>
            <.header_link href={~p"/users/register"}>Register</.header_link>
            <.header_link href={~p"/users/log_in"}>Log in</.header_link>
          <% end %>
        </div>
      </div>
    </header>
    """
  end

  attr :href, :any, required: true
  attr :method, :any, default: "get"
  slot :inner_block, required: true

  defp header_link(assigns) do
    ~H"""
    <.link
      href={@href}
      method={@method}
      class="text-[0.8125rem] font-semibold leading-6 text-gray-400 hover:text-gray-300"
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
