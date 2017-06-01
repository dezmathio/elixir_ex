defmodule HoundPlayground do
  
  use Hound.Helpers
  use Timex

  def check_for_status(_url) do
    {:ok, "200"}
  end
 
  def theory do
    # {:ok, _} = Application.ensure_all_started(:hound) # not needed in test env cuz of test_helper.exs
    start_time = Duration.now
    url = "http://www.google.com"
    slave_process_browser(url, start_time)
  end

  def slave_process_browser(url, start_time) do
    Hound.start_session
    navigate_to(url)
    |> check_for_status
    |> build_custom_output(url, start_time)
  end

  def build_custom_output(status, url, start_time) do
    total_duration = Duration.diff(Duration.now, start_time, :milliseconds)
    status_code = elem(status, 1)
    IO.inspect %{status: status_code, url: url, time_spent: total_duration}
    Hound.end_session
  end
end

defmodule HoundTestTest do
  use ExUnit.Case
  use Hound.Helpers

  test "should get a successful request from google" do
    use Hound.Helpers
    Application.ensure_all_started(:hound)
    # this is not working :< 
    Hound.start_session(
      driver: %{
        browserName: "chrome",
        chromeOptions: %{"args" => [
          "--user-agent=Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
          "--headless",
          "--disable-gpu",
          "--no-first-run",
          "--remote-debugging-port=9222",
          "--window-size=1366x768" # NOTICE: run tests on desktop by default!!!
        ]
        }
      }
    )

    HoundPlayground.theory
  end
end

