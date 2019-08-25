defmodule BatteryStaple.PasswordGenerator do
  @moduledoc false

  defmodule LoadDictionnary do
    @moduledoc false
    def load(path) do
      path
      |> File.stream!(encoding: :utf8)
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.into(MapSet.new())
    end
  end

  @dicts %{
    "en" => {LoadDictionnary.load("dicts/en_basic.txt"), "English", "🇬🇧"},
    "fr" => {LoadDictionnary.load("dicts/fr_basic.txt"), "Français", "🇫🇷"}
  }

  def generate_password(nb_words, dicts \\ ["en"], separator \\ "-") do
    Enum.map_join(1..max(1, nb_words), separator, fn _ -> "#{get_word(dicts)}" end)
  end

  defp get_word(dicts) do
    dicts
    |> Enum.random()
    |> get_dict()
    |> elem(0)
    |> Enum.random()
  end

  def get_dicts(), do: @dicts
  defp get_dict(lang), do: get_dicts()[lang]
end
