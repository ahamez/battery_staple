defmodule BatteryStapleWeb.PasswordView do
  require Logger
  use Phoenix.LiveView

  @initial_length "4"

  def render(assigns) do
    BatteryStapleWeb.PageView.render("password.html", assigns)
  end

  def mount(_session, socket) do
    Logger.debug("Socket connected: #{connected?(socket)}")

    {:ok, assign(socket, password: generate_password(@initial_length), length: @initial_length)}
  end

  def handle_event("update_length", %{"length" => length}, socket) do
    {:noreply, assign(socket, password: generate_password(length), length: length)}
  end

  def handle_event("gen_passwd", _value, socket) do
    {:noreply, assign(socket, password: generate_password(socket.assigns.length))}
  end

  defp generate_password(length) do
    BatteryStaple.PasswordGenerator.generate_password(String.to_integer(length))
  end
end
