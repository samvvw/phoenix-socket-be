defmodule ChatAppEctoWeb.PingChannel do
  use Phoenix.Channel
  alias ChatAppEctoWeb.Presence

  def join("topic:" <> user_id, payload, socket) do
    user = payload["user"]

    send(self(), :after_join)

    {:ok, assign(socket, :name, user)}
  end

  def handle_in("ping", payload, socket) do
    broadcast(socket, "pong", %{ping: "pong"})

    {:noreply, socket}
  end

   def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.name, %{
        online_at: inspect(System.system_time(:second))
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
