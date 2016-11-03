defmodule Markets.Market do
  use Ecto.Schema
  @derive {Poison.Encoder, only: [:path, :name, :exposure]}
  schema "market_tree" do
    field :path, :string
    field :name, :string
    field :exposure, :decimal

    timestamps
  end
end
