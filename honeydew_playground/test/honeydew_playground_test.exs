defmodule HeavyTask do
  def work_really_hard(secs) do
    :timer.sleep(1_000 * secs)
    IO.puts "I worked really hard for #{secs} secs!"
  end
end


defmodule QueueApp do
  def start do
    nodes = [node()]

    children = [
      Honeydew.queue_spec({:global, :my_queue}, queue: {Honeydew.Queue.Mnesia, [nodes, [disc_copies: nodes], []]})
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule WorkerApp do
  def start do
    children = [
      Honeydew.worker_spec({:global, :my_queue}, HeavyTask, num: 10)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end


defmodule HoneydewPlaygroundTest do
  use ExUnit.Case
  doctest HoneydewPlayground

  test "I can start the Worker App" do
    QueueApp.start
    WorkerApp.start
    {:work_really_hard, [5]} |> Honeydew.async({:global, :my_queue})
  end

  test "I can run HeavyTask independently" do
    HeavyTask.work_really_hard(5)
  end

end
