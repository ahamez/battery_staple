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

  def generate_password(nb_words, separator \\ "-", dicts \\ [:en_basic]) do
    Enum.map_join(1..max(1, nb_words), separator, fn _ -> "#{get_word(dicts)}" end)
  end

  defp get_word(dicts) do
    dicts |> Enum.random() |> get_dict |> Enum.random()
  end

  @dicts %{
    # en: {LoadDictionnary.load("en.txt"), "English 🇬🇧"},
    en_basic: {LoadDictionnary.load("en_basic.txt"), "Basic English 🇬🇧"}
    # fr: {LoadDictionnary.load("fr.txt"), "Français 🇫🇷"}
  }

  def get_dicts, do: @dicts
  defp get_dict(dict), do: get_dicts()[dict] |> elem(0)
end
