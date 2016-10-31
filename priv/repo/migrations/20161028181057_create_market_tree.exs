defmodule Markets.Repo.Migrations.CreateMarketTree do
  use Ecto.Migration

  def change do
    create table(:market_tree) do
      add :path, :ltree
      add :name, :string
      add :exposure, :decimal

      timestamps
    end

    create index(:market_tree, [:path], using: "GIST")
 
  end
end
