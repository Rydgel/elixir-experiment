defmodule ParserTest do
  use ExUnit.Case, async: true
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of headers fields into a map" do
    headers_line = ["A: 1", "B: 2"]
    headers = Parser.parse_headers(headers_line)
    assert headers == %{"A" => "1", "B" => "2"}
  end
end
