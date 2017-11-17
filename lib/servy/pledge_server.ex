defmodule Servy.PledgeServer do
  @moduledoc """
  """

  @process_name :pledge_server

  use GenServer

  defmodule State do
    @moduledoc """
    """
    defstruct cache_size: 3, pledges: []
  end

  def start do
    IO.puts "Starting the pledge server..."
    GenServer.start(__MODULE__, %State{}, name: @process_name)
  end

  def create_pledge(name, amount) do
    GenServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @process_name, :recent_pledges
  end

  def total_pledges do
    GenServer.call @process_name, :total_pledges
  end

  def clear do
    GenServer.cast @process_name, :clear
  end

  def set_cache_size(size) do
    GenServer.cast @process_name, {:set_cache_size, size}
  end

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    {:ok, %{state | pledges: pledges}}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  def handle_call(:total_pledges, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info(message, state) do
    IO.puts "Can't touch this! #{inspect message}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE to getch recent pledges from server
    # Example:
    [{"wilma", 15}, {"fred", 25}]
  end
end
