defmodule BatteryStapleWeb.PasswordView do
  require Logger
  use Phoenix.LiveView

  @initial_length "4"
  @initial_langs [:en]

  def render(assigns) do
    BatteryStapleWeb.PageView.render("password.html", assigns)
  end

  def mount(_session, socket) do
    Logger.debug("Socket connected: #{connected?(socket)}")

    {:ok,
     assign(socket,
       password: generate_password(@initial_length, @initial_langs),
       length: @initial_length,
       langs: @initial_langs
     )}
  end

  def handle_event("update_length", %{"length" => length}, socket) do
    {:noreply,
     assign(socket, password: generate_password(length, socket.assigns.langs), length: length)}
  end

  def handle_event("gen_passwd", _value, socket) do
    {:noreply,
     assign(socket, password: generate_password(socket.assigns.length, socket.assigns.langs))}
  end

  def dictionaries() do
    BatteryStaple.PasswordGenerator.get_dicts()
  end

  defp generate_password(length, langs) do
    BatteryStaple.PasswordGenerator.generate_password(String.to_integer(length), langs)
  end
end
