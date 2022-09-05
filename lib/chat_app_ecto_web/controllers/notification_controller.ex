defmodule ChatAppEctoWeb.NotificationController do
  use ChatAppEctoWeb, :controller
  # alias ChatAppEctoWeb.NotificationsChannel, as: NotificationsChannel

  def index(conn, params) do


    avatar = params["avatar"]
    # avatar_sample = "https://i.pravatar.cc/" <> to_string(:rand.uniform(300))

    avatar_options = %{
      "avatar_sample" => "https://i.pravatar.cc/" <> to_string(:rand.uniform(300)),
      "beach" => "dist/beach.svg",
      "marine" => "dist/marine.svg"
    }

    avatar_list = ["avatar_sample", "beach", "marine"]
    subject = params["subject"]
    description = params["description"]
    notification_link = params["notification_link"]
    user_id = params["user_id"]
    avatar_result = avatar_options[Enum.at(avatar_list, String.to_integer(avatar) )]

    IO.inspect("_____yyyyy___")
    IO.inspect(avatar)
    IO.inspect("_____yyyyy___")
    IO.inspect(avatar_options)
    IO.inspect("_____yyyyy___")
    IO.inspect(avatar_result)
    IO.inspect("_____yyyyy___")


    # notification_data = %{subject: subject, description: description, notification_link: notification_link, avatar_logo: "https://i.pravatar.cc/" <> avatar}
    notification_data = %{subject: subject, description: description, notification_link: notification_link, avatar_logo: avatar_result }
    ChatAppEctoWeb.Endpoint.broadcast!("notifications:" <> user_id, "notify", notification_data)

    json(conn, %{hi: "there", notification_data: notification_data})

  end
end
