defmodule MyPlug do
  import Plug.Conn

  def init(options) do
    # initialize options

    options
  end

  def call(conn, _opts) do
    list = [200, 404, 500]
    random_number = {:ok, Enum.random(list)}
    make_req(conn, elem(random_number, 1))
  end

  def make_req(conn, code) do
    IO.puts "response #{code}"
    conn
      |> put_resp_content_type("text/plain")
      |> send_resp(code, "#{code}")    
  end
end

{:ok, _} = Plug.Adapters.Cowboy.http MyPlug, [], [port: 4001]

