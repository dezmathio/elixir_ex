# defmodule WW.RailsQueue do
#   use GenServer
#   alias WW.RailsQueue.Pool

#   def start_link() do
#     GenServer.start_link __MODULE__, {[], []}, name: __MODULE__
#   end

#   @agent Module.concat(__MODULE__, Agent)
#   def init(state) do
#     agent = @agent
#             |> Process.whereis
#             |> agent(state)

#     {:ok, agent}
#   end

#   defp agent(nil, state) do
#     {:ok, new_agent} = Agent.start(fn -> state end, name: @agent)
#     new_agent
#   end
#   defp agent(pid, _) when is_pid(pid), do: pid

#   @push Application.get_env(:ww, WW.RailsQueue)[:push]
#   def handle_cast({:queue, request}, agent) do
#     item = {make_ref(), request}

#     if @push do
#       agent
#       |> Pool.queue_work(item)

#       GenServer.cast(__MODULE__, :delegate)
#     end

#     {:noreply, agent}
#   end

#   def handle_cast(:delegate, agent) do
#     Task.start __MODULE__, :delegate_work, [agent]

#     {:noreply, agent}
#   end

#   def delegate_work(agent) do
#     :poolboy.transaction(Pool.name, fn(worker)-> Pool.perform_work(agent) end)
#   end

#   ### Client API ###

#   # queue("some.url/to/hit", :get, %{data: :here}, "api-token", "name-of-channel-to-broadcast-to-once-complete")

#   def queue(url, method, data, token, broadcast_to) when is_map(data) do
#     queue(url, method, Poison.encode!(data), token, broadcast_to)
#   end

#   def queue(url, method, data, token, broadcast_to) do
#     GenServer.cast __MODULE__, {:queue, {method, url, data, token, broadcast_to}}
#   end

#   def queue(url, method, data, token, broadcast_to \\ nil), do: queue(url, method, data, token, broadcast_to)
# end