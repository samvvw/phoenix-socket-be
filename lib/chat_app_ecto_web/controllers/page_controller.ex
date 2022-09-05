defmodule ChatAppEctoWeb.PageController do
  use ChatAppEctoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", username: "Home of Coquito el Phoenix!!!")
  end
end
