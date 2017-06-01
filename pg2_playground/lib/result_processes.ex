defmodule ResultsProcesses do
  def publish(message) do
    for pid <- :pg2.get_members(:results_group) do
      send(pid, {self(), message})
    end
  end

  def add_process(module) do
    :pg2.create(:results_group)
    pid = apply(module, :start, [])
    :pg2.join(:results_group, pid)
    pid
  end
end

defmodule ResultsProcesses.Process.MakePretty do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, message} -> send(pid, {__MODULE__, ResultsHelper.make_result_pretty(message)})
    end
    await()
  end
end

defmodule ResultsProcesses.Process.Appender do
  def start do
    spawn(__MODULE__, :await, [])
  end

  def await do
    receive do
      {pid, message} -> send(pid, {__MODULE__, "appended result: #{message}"})
    end
    await()
  end
end 