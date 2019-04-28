defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_ascending_order: 1]

  test ":help returned by option parsing with -h and --help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "Four values returned if three given" do
    assert parse_args(["user", "project", "issues"]) == {"user", "project", "issues", 4}
  end

  test "Four values returned if four given" do
    assert parse_args(["user", "project", "pulls", "99"]) == {"user", "project", "pulls", 99}
  end

  test "Count and type are defaulted if two given" do
    assert parse_args(["user", "project"]) == {"user", "project", "issues", 4}
  end

  test "sort into ascending order the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{a b c}  
  end

  defp fake_created_at_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
