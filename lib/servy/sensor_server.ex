defmodule Servy.SensorServer do
  @moduledoc """
  """

  @process_name :sensor_server
  @refresh_interval :timer.seconds(5)

  use GenServer

  # Client interface

  def start do
    GenServer.start(__MODULE__, %{}, name: @process_name)
  end

  def get_sensor_data do
    GenServer.call @process_name, :get_sensor_data
  end

  # Server callbacks

  def init(_state) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  def handle_info(unexpected, state) do
    IO.puts "Can't touch this! #{inspect unexpected}"
    {:noreply, state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def handle_call(:get_sensor_data, _msg, state) do
    {:reply, state, state}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    task = Task.async(Servy.Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
