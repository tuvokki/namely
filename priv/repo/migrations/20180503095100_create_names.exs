defmodule Namely.Repo.Migrations.CreateNames do
  use Ecto.Migration

  def change do
    create table(:names) do
      add(:name, :string)
      add(:description, :string)
      timestamps()
    end

    create(unique_index(:names, [:name]))
  end
end
