defmodule WallabyPlayground do
  use Wallaby.DSL
  use Timex

  def check_for_status(url) do
    {:ok, "200"}
  end
 
  def theory do
    {:ok, _} = Application.ensure_all_started(:wallaby)
    start_time = Duration.now
    url = "http://www.google.com"
    slave_process_browser(url, start_time)
  end

  def slave_process_browser(url, start_time) do
    {:ok, user1} = Wallaby.start_session
      user1
      |> visit(url)
      |> check_for_status
      |> build_custom_output(url, start_time)
  end

  def build_custom_output(status, url, start_time) do
    total_duration = Duration.diff(Duration.now, start_time, :milliseconds)
    status_code = elem(status, 1)
    IO.inspect %{status: status_code, url: url, time_spent: total_duration}
    
  end
end

defmodule WallabyTestTest do
  use ExUnit.Case

  test "should get a successful request from google" do
    WallabyPlayground.theory
  end
end

