# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Markets.Repo.insert!(%ReleaseScheduleWebpack.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Markets.Repo

defmodule Markets.Seeds do

  def update_market_tree(%{ :exposure => exposure, :level0 => level0, :level1 => level1, :level2 => level2, :level3 => level3}, tree_nodes) do
    key_terms = [level0, level1, level2, level3]
    {keys, _} =
      Enum.map_reduce(key_terms, 1, fn(term, acc) ->
        terms = Enum.take(key_terms, acc)
        keys = create_path_key(terms)
        {keys, acc+1}
      end)

    {result, _} =
      Enum.reduce(keys, {tree_nodes, String.to_float(exposure)}, fn({:ok,key, name}, acc) ->
      {current_nodes, exposure} = acc
      new_nodes =
        Map.update(current_nodes, key, %{name: name, exposure: exposure}, fn(current_value) ->
        %{:name => current_name, :exposure => current_exposure  } = current_value
        %{name: name, exposure: current_exposure + exposure}
      end)
      {new_nodes, exposure}
      end)
    result
  end

  def clean_term(term) do
    cleaned_term =
      String.trim(term)
      |> String.replace(" ", "_")
      |> String.replace("&", "and")
      |> String.downcase
    {:ok, cleaned_term}
  end

  def create_path_key(terms) when is_list(terms) do
    Enum.reduce_while(terms, {:ok, nil}, fn(term, acc) ->
      case {clean_term(term), acc} do
        {{:ok, cleaned_term}, {:ok, nil}} -> {:cont, {:ok, cleaned_term, term}}
        {{:error, cleaned_term}, _} -> {:halt, {:error, cleaned_term, term}}
        {{:ok, cleaned_term}, {:ok, path_key, _}} -> {:cont, {:ok,  path_key <> "." <> cleaned_term, term}}
      end
    end)
  end
end

File.stream!("./test_data/MarketsCSV.csv")
|> Stream.drop(1)
|> CSV.decode(separator: ?;, headers: [:level0, :level1, :level2, :level3, :exposure])
|> Enum.reduce(%{},&(Markets.Seeds.update_market_tree(&1, &2)))
|> Enum.each(&(IO.inspect &1))
