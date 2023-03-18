defmodule HandleCommerce.Repo do
  use Ecto.Repo,
    otp_app: :handle_commerce,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [from: 2]

  @spec archive(struct) :: {:ok, struct} | {:error, Ecto.Changeset.t()}
  def archive(%{archived_at: _} = struct) do
    struct
    |> archive_changeset()
    |> update()
  end

  def archive_changeset(%{archived_at: _} = struct) do
    struct
    |> Ecto.Changeset.cast(%{"archived_at" => DateTime.utc_now()}, [:archived_at])
  end

  @spec unarchived(Ecto.Queryable.t()) :: Ecto.Query.t()
  # Filter out all archived records
  def unarchived(queryable), do: from(q in queryable, where: is_nil(q.archived_at))
end
