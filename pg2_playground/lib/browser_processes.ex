defmodule BrowserProcesses do
  def publish(message) do
    for pid <- :pg2.get_members(:browser_group) do
      send(pid, {self(), message})
    end
  end

  def add_process(module) do
    :pg2.create(:browser_group)
    pid = apply(module, :start, [])
    :pg2.join(:browser_group, pid)
    pid
  end
end

defmodule BrowserProcesses.Process.Visit do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, url} -> send(pid, {__MODULE__, BrowserHelper.visit_url(url)})
    after
      30_000 -> "nothing after 30s"
    end
    await()
  end
end

defmodule BrowserProcesses.Process.VisitWithCookie do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, {url, cookie}} -> send(pid, {__MODULE__, BrowserHelper.visit_url_with_cookie(url, cookie)})
    end
    await()
  end
end 

defmodule BrowserProcesses.Process.VisitAndClick do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, {url, selector}} -> send(pid, {__MODULE__, BrowserHelper.visit_url_and_click_selector(url, selector)})
    end
    await()
  end
end 

defmodule BrowserProcesses.Process.VisitAndClickWithCookie do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, {url, cookie, selector} } -> send(pid, {__MODULE__, BrowserHelper.visit_url_with_cookie_and_click_selector(url, cookie, selector)})
    end
    await()
  end
end 
