defmodule Issues.GithubIssues do
  
  require Logger
  
  @user_agent [ {"User-agent", "Elixir dave@pragprog.com"} ]
  @github_url Application.get_env(:issues, :github_url)



  def fetch(user, project, type \\ "issues") do
    Logger.info "Fetching user #{user}'s project #{project} of type #{type}"

    api_url(user, project, type)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp api_url(user, project, type), do: "#{@github_url}/repos/#{user}/#{project}/#{type}"

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    {:ok, Poison.Parser.parse!(body, %{})}
  end

  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    {:error, Poison.Parser.parse!(body, %{})}
  end
end