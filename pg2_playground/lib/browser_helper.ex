defmodule BrowserHelper do
  use Hound.Helpers
  use Timex
  
  def visit_url(url) do
    "visit url: #{url}"
    start_time = Duration.now
    execute_visit(url, start_time)
  end

  def visit_url_with_cookie(url, cookie) do
    "visit url: #{url} with cookie: #{cookie}"
  end

  def visit_url_and_click_selector(url, selector) do
    "visit url: #{url}, click selector: #{selector}"
  end

  def visit_url_with_cookie_and_click_selector(url, cookie, selector) do
    "visit url: #{url}, click selector: #{selector}, with cookie: #{cookie}"
  end

  def check_for_status(_url) do
    200
  end

  def execute_visit(url, start_time) do
    Hound.start_session
    navigate_to(url)
    |> check_for_status
    |> build_result_output(url, start_time)
  end




  def build_result_output(status, url, start_time) do
    total_duration = Duration.diff(Duration.now, start_time, :milliseconds)
    status_code = elem(status, 1)
    result = %{status: status_code, url: url, time_spent: total_duration}
    IO.inspect result
    Hound.end_session
    ResultsProcesses.add_process(ResultsProcess.Process.MakePretty)
    ResultsProcesses.publish(result)

  end


end