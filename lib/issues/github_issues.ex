defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir dave@pragprog.com"} ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project, type \\ "issues") do
    api_url(user, project, type)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp api_url(user, project, type), do: "#{@github_url}/repos/#{user}/#{project}/#{type}"

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body, %{})}
  end

  defp handle_response({_, %{status_code: _, body: body}}) do
    {:error, Poison.Parser.parse!(body, %{})}
  end
end