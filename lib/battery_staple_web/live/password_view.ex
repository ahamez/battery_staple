defmodule BatteryStappleWeb.PasswordView do
  require Logger
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <h1><%= @password %></h1>
      </div>
      <div>
        <button phx-click="gen_passwd">Generate Password</button>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    Logger.debug("Socket connected: #{connected?(socket)}")

    {:ok, assign(socket, password: BatteryStaple.PasswordGenerator.generate_password(4))}
  end

  def handle_event("gen_passwd", _value, socket) do
    {:noreply, assign(socket, password: BatteryStaple.PasswordGenerator.generate_password(4))}
  end
end
