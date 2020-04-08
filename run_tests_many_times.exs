defmodule Bench do
  @iterations 50

  def run_one(version) do
    1..@iterations
    |> Enum.map(fn iteration ->
      IO.puts("version: #{version} iteration: #{iteration}")

      {_output, return_value} =
        System.cmd("docker-compose", ["exec", "-T", "test-#{version}", "mix", "test"])

      return_value
    end)
  end

  def run_all() do
    versions = ["21.2", "21.3", "22.3"]

    results =
      versions
      |> Task.async_stream(&run_one/1, timeout: 120 * 3600)
      |> Enum.to_list()
      |> Keyword.values()
      |> Enum.map(&Enum.frequencies/1)

    IO.puts("====================================")

    versions
    |> Enum.zip(results)
    |> Enum.each(fn {version, result} ->
      success_count = result |> Map.get(0, 0)

      IO.puts(
        "[#{version}] Successes: #{success_count / @iterations * 100}% Failures: #{
          (@iterations - success_count) / @iterations * 100
        }%"
      )
    end)
  end
end

Bench.run_all()
