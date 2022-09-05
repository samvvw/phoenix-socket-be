defmodule ChatAppEctoWeb.NotificationsChannel do
  use Phoenix.Channel

  def join("notifications:" <> user_id, payload, socket) do
    user = payload["user"]
    send(self(), :after_join)
    {:ok, assign(socket, :name, user)}
  end

  def handle_in("load_notifications", payload, socket) do

    broadcast(socket, "load_notifications", %{ notifications: [%{subject: "Time off <b>Request Approved</b>", description: "Your manager has approved your time off request for Tuesday", notification_link: "http://localhost:3000", avatar_logo: "https://i.pravatar.cc/" <> to_string(:rand.uniform(300))}, %{subject: "Time off Request Approved", description: "Your manager has approved your time off request for Tuesday", notification_link: "http://localhost:3000", avatar_logo: "https://i.pravatar.cc/" <> socket.assigns.user_id}]})
    {:noreply, socket}
  end

  def handle_out("notify", payload, socket) do
    IO.inspect("_____________")
    IO.inspect("_____________")
    IO.inspect(socket)
    IO.inspect("_____________")
    IO.inspect("_____________")
    push(socket, "notify", payload)
    {:noreply, socket}
  end
end
