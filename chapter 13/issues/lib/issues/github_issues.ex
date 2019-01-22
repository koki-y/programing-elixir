defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir dave@pragprog.com"} ]
  @github_url Application.get_env(:issues, :github_url)
  @proxy_url  System.get_env("http_proxy")

  def fetch(user, project) do
    make_url(user, project)
    |> get_issues(@user_agent, @proxy_url)
    |> handle_response
  end

  def make_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def get_issues(url, agent, proxy), do: HTTPoison.get url, agent, proxy: proxy
  def get_issues(url, agent, nil),   do: HTTPoison.get url, agent

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    { :ok,    Poison.Parser.parse!(body) }
  end
  def handle_response({  _, %{status_code:   _, body: body}}) do
    { :error, Poison.Parser.parse!(body) }
  end
end
