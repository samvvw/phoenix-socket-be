defmodule ChatAppEcto.Repo do
  use Ecto.Repo,
    otp_app: :chat_app_ecto,
    adapter: Ecto.Adapters.Postgres
end
