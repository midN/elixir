defmodule Stockman.Repo.Migrations.CreateConvert do
  use Ecto.Migration

  def change do
    create table(:converts) do
      add :base_currency, :string
      add :target_currency, :string
      add :amount, :decimal
      add :waiting_time, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:converts, [:user_id])

  end
end
