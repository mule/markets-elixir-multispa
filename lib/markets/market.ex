defmodule Markets.Market do
  use Ecto.Schema

  schema "market_tree" do
    field :path, :string
    field :name, :string
    field :exposure, :decimal

    timestamps
  end
end
