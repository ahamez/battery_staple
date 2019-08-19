defmodule BatteryStappleWeb.PasswordView do
  require Logger
  use Phoenix.LiveView

  @initial_length 4

  def render(assigns) do
    ~L"""
      <%= @password %>
      <form phx-change="update_length">
        <input type="range" min="3" max="10" name="length" value="<%= @length %>" />
      </form>
      <%= @length %>
      <div>
        <button phx-click="gen_passwd" value="<%= @length %>">Generate new password</button>
      </div>
    """
  end


  def mount(_session, socket) do
    Logger.debug("Socket connected: #{connected?(socket)}")

    {:ok, assign(socket, password: generate_password(@initial_length), length: @initial_length)}
  end

  def handle_event("update_length", %{"length" => length}, socket) do
    {:noreply, assign(socket, password: generate_password(length), length: length)}
  end

 def handle_event("gen_passwd", value, socket) do
    {:noreply, assign(socket, password: generate_password(value))}
  end


  defp generate_password(length) when is_binary(length) do
    BatteryStaple.PasswordGenerator.generate_password(String.to_integer(length))
  end

  defp generate_password(length) do
    BatteryStaple.PasswordGenerator.generate_password(length)
  end
end
