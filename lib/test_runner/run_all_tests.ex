defmodule Mix.Tasks.RunAllTests do
  use Mix.Task
  alias TestRunner.Versions

  @shortdoc "Generate docker-compose.override.yml"

  @impl Mix.Task

  @iterations 20

  def run(_) do
    versions = Versions.versions()
    run_all(versions)
  end

  defp exec_command(service, command) do
    System.cmd("docker-compose", ["exec", "-T", service] ++ command)
  end

  def run_one({elixir_version, otp_version} = version) do
    1..@iterations
    |> Enum.map(fn iteration ->
      IO.puts("version: #{inspect(version)} iteration: #{iteration}")
      service = "test_#{elixir_version}_#{otp_version}"

      {_output, 0} = exec_command(service, ["mix", "deps.get"])
      {_output, return_value} = exec_command(service, ["mix", "test"])

      return_value
    end)
  end

  def run_all(versions) do
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
        "[#{inspect(version)}] Successes: #{success_count / @iterations * 100}% Failures: #{
          (@iterations - success_count) / @iterations * 100
        }%"
      )
    end)
  end
end
