defmodule ChatAppEctoWeb.NotificationsSocket do
  use Phoenix.Socket
  channel "notifications:*", ChatAppEctoWeb.NotificationsChannel


  def connect(params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, params["user_id"])}
  end

  def id(socket), do: "notifications_socket: #{socket.assigns.user_id}"
end
