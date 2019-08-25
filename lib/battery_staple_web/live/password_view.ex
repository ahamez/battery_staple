defmodule BatteryStapleWeb.PasswordView do
  require Logger
  use Phoenix.LiveView

  @initial_length "4"
  @initial_lang "en"

  def render(assigns) do
    BatteryStapleWeb.PageView.render("password.html", assigns)
  end

  def mount(_session, socket) do
    Logger.debug("Socket connected: #{connected?(socket)}")

    {:ok,
     assign(socket,
       password: generate_password(@initial_length, @initial_lang),
       length: @initial_length,
       lang: @initial_lang
     )}
  end

  def handle_event("update", values, socket) do
    Logger.debug("#{inspect(values)}")

    length = values["length"]
    lang = values["lang"]

    {:noreply,
     assign(socket,
       password: generate_password(length, lang),
       length: length,
       lang: lang
     )}
  end

  def handle_event("gen_passwd", _value, socket) do
    {:noreply,
     assign(socket, password: generate_password(socket.assigns.length, socket.assigns.lang))}
  end

  def dictionaries() do
    BatteryStaple.PasswordGenerator.get_dicts()
  end

  defp generate_password(length, lang) do
    BatteryStaple.PasswordGenerator.generate_password(String.to_integer(length), [lang])
  end
end
