defmodule Servy.Fetcher do
  @moduledoc """
  This will we replaced by Task
  """

  @doc """
  """
  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  @doc """
  """
  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end
end
