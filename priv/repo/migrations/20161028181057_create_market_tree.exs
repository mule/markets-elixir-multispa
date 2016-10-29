defmodule Markets.Repo.Migrations.CreateMarketTree do
  use Ecto.Migration

  def change do
    create table(:market_tree) do
      add :path, :string
      add :name, :string
      add :exposure, :decimal
    end

  end
end
