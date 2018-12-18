defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generation a
  table of the last _n_ issues in a gihub project
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or ``
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _, _ }
        -> :help
      { _, [ user, project, count ], _ }
        -> { user, project, String.to_integer(count)}
      { _, [ user, project, ], _ }
        -> { user, project, @default_count }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> withdraw_necessary_data
    |> print_date
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end

  def withdraw_necessary_data(list_of_issues) do
    Enum.map list_of_issues,
      fn issue -> [issue["number"], issue["created_at"], issue["title"],
                   String.length(Integer.to_string(issue["number"])), String.length(issue["title"])]
      end
  end

  def measure_num_length([], num_max), do: num_max
  def measure_num_length([[_, _, _, num_len, _] | tail], num_max)
    when num_len > num_max do
      measure_num_length([tail], num_len)
  end
  def measure_num_length([_ | tail], num_max), do: measure_num_length(tail, num_max)

  def measure_title_length([], title_max), do: title_max
  def measure_title_length([[_, _, _, _, title_len] | tail], title_max)
    when title_len > title_max do
      measure_title_length([tail], title_len)
  end
  def measure_title_length([_ | tail], title_max), do: measure_title_length(tail, title_max)

  def print_date(list_of_issues) do
    num_max   = measure_num_length(list_of_issues, 0)
    title_max = measure_title_length(list_of_issues, 0)
    num = String.duplicate(" ", round((num_max - 1) / 2)) <> "#" <> String.duplicate(" ", trunc((num_max - 1) / 2))
    IO.puts "#{num} | crated_at            | title"
    IO.puts String.duplicate("-", num_max) <> "-+----------------------+-" <> String.duplicate("-", title_max)
    print_date(list_of_issues, num_max)
  end
  def print_date([], _), do: :ok
  def print_date([[num, data, title, num_len, _] | tail], num_max) do
    IO.puts String.duplicate(" ", num_max - num_len) <> Integer.to_string(num) <> " | " <> data <> " | " <> title
    print_date(tail, num_max)
  end
end
