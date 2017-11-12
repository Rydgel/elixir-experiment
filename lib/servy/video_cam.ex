defmodule Servy.VideoCam do
  @moduledoc """
  """
  
  @doc """
  Simulates a request to an external API
  to get a snapshot image from a video camera.
  """
  def get_snapshot(camera_name) do
    # sleep for 1s to simulate that the API is slow
    :timer.sleep(1000)
    # return the filename
    "#{camera_name}-snapshot-#{:rand.uniform(1000)}.jpg"
  end
end
