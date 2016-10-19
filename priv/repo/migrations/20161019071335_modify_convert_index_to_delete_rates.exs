defmodule Stockman.Repo.Migrations.ModifyConvertIndexToDeleteRates do
  use Ecto.Migration

  def change do
    drop constraint(:rates, "rates_convert_id_fkey")

    alter table(:rates) do
      modify :convert_id, references(:converts, on_delete: :delete_all)
    end
  end
end
