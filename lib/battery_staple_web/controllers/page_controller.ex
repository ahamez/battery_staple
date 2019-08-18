defmodule BatteryStapleWeb.PageController do
  use BatteryStapleWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _) do
    LiveView.Controller.live_render(conn, BatteryStappleWeb.PasswordView, session: %{})
  end
end
