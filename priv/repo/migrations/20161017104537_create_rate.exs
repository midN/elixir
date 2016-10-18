defmodule Stockman.Repo.Migrations.CreateRate do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :date, :date
      add :rate, :decimal
      add :convert_id, references(:converts, on_delete: :nothing)

      timestamps()
    end
    create index(:rates, [:convert_id])

  end
end
