defmodule Servy.BearController do
  @moduledoc """
  """

  alias Servy.Wildthings
  alias Servy.BearView

  def index(conv) do
    bears =
      Wildthings.list_bears
      |> Enum.sort(&(&1.name <= &2.name))

    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: BearView.show(bear)}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
