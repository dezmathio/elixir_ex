defmodule BrowserProcessesTest do
  use ExUnit.Case

  setup do
    on_exit fn ->
      :pg2.delete(:results_group)
      :pg2.delete(:browser_group)
    end
  end

  test "results group should return a message" do
    ResultsProcesses.add_process(ResultsProcesses.Process.MakePretty)
    ResultsProcesses.publish("corndog")
    assert_receive {ResultsProcesses.Process.MakePretty, "single result is: corndog"}
  end
  
  test "multiple processes can be added to results group" do
    ResultsProcesses.add_process(ResultsProcesses.Process.MakePretty)
    ResultsProcesses.add_process(ResultsProcesses.Process.Appender)
    ResultsProcesses.publish("canoe")
    assert_receive {ResultsProcesses.Process.MakePretty, "single result is: canoe"}
    assert_receive {ResultsProcesses.Process.Appender, "appended result: canoe"}
  end

  test "browser group should visit a given url" do
    BrowserProcesses.add_process(BrowserProcesses.Process.Visit)
    BrowserProcesses.publish("www.google.com")
    assert_receive {BrowserProcesses.Process.Visit, "visit url: www.google.com"}
  end

  test "browser group should visit a given url and cookie" do
    BrowserProcesses.add_process(BrowserProcesses.Process.VisitWithCookie)
    BrowserProcesses.publish({"www.google.com", "cookie-example"})
    assert_receive {BrowserProcesses.Process.VisitWithCookie, "visit url: www.google.com with cookie: cookie-example"}
  end

  test "browser group should visit a given url and click on selector" do
    BrowserProcesses.add_process(BrowserProcesses.Process.VisitAndClick)
    BrowserProcesses.publish({"www.google.com", ".tuna"})
    assert_receive {BrowserProcesses.Process.VisitAndClick, "visit url: www.google.com, click selector: .tuna"}
  end

  test "browser group should visit a given url and click on selector and have a cookie" do
    BrowserProcesses.add_process(BrowserProcesses.Process.VisitAndClickWithCookie)
    BrowserProcesses.publish({"www.google.com","cookie-example", ".tuna"})
    assert_receive {BrowserProcesses.Process.VisitAndClickWithCookie, "visit url: www.google.com, click selector: .tuna, with cookie: cookie-example"}
  end
end
