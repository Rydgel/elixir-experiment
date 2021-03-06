defmodule Servy.Parser do
  @moduledoc """
  """

  alias Servy.Conv

  def parse(request) do
    [top, params_string] =
      String.split(request, "\r\n\r\n")

    [request_line | header_lines] =
      String.split(top, "\r\n")

    headers = parse_headers(header_lines)

    [method, path, _] =
      String.split(request_line, " ")

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers,
    }
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with coresponding keys and values.

  ## Examples
      iex> params_string = "name=Baloo&type=Brown"
      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy.Parser.parse_params("multipart/form-data", params_string)
      %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers(header_line) do
    Enum.reduce header_line, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers, key, String.trim(value))
    end
  end
end
