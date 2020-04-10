defmodule Mix.Tasks.RunAllTests do
  use Mix.Task
  alias TestRunner.Versions

  @shortdoc "Generate docker-compose.override.yml"

  @impl Mix.Task

  @default_number_of_number_of_iterations 10

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args, switches: [no_stop_after: :boolean, iterations: :integer])

    number_of_iterations = opts |> Keyword.get(:iterations, @default_number_of_number_of_iterations)
    stop_after = opts |> Keyword.get(:no_stop_after, false) |> Kernel.not()

    if number_of_iterations < 1 do
      raise "Invalid value for number_of_iterations"
    end

    versions = Versions.versions()
    run_all(versions, number_of_iterations, stop_after)
  end

  defp exec_command(service, command) do
    System.cmd("docker-compose", ["exec", "-T", service] ++ command, stderr_to_stdout: true)
  end

  def run_one({elixir_version, otp_version} = version, number_of_iterations, stop_after) do
    service = "test_#{elixir_version}_#{otp_version}"

    IO.puts("version: #{inspect(version)} build")
    {_output, 0} = System.cmd("docker-compose", ["build", service], stderr_to_stdout: true)
    IO.puts("version: #{inspect(version)} up")
    {_output, 0} = System.cmd("docker-compose", ["up", "-d", service], stderr_to_stdout: true)
    IO.puts("version: #{inspect(version)} deps.get")
    {_output, 0} = exec_command(service, ["mix", "deps.get"])
    IO.puts("version: #{inspect(version)} deps.compile")
    {_output, 0} = exec_command(service, ["mix", "deps.compile"])

    return_values = 1..number_of_iterations
    |> Enum.map(fn iteration ->
      IO.puts("version: #{inspect(version)} iteration: #{iteration}")
      {_output, return_value} = exec_command(service, ["mix", "test"])
      return_value
    end)

    if stop_after do
      System.cmd("docker-compose", ["stop", service])
    end

    return_values
  end

  def run_all(versions, number_of_iterations, stop_after) do
    System.cmd("docker-compose", ["up", "-d", "kafka1"])

    results =
      versions
      |> Task.async_stream(&run_one(&1, number_of_iterations, stop_after),
        timeout: 240 * 3600,
        max_concurrency: 3,
        ordered: true
      )
      |> Enum.to_list()
      |> Keyword.values()
      |> Enum.map(&Enum.frequencies/1)

    IO.puts("====================================")

    versions
    |> Enum.zip(results)
    |> Enum.each(fn {version, result} ->
      success_count = result |> Map.get(0, 0)

      IO.puts(
        "[#{inspect(version)}] Successes: #{success_count / number_of_iterations * 100}% Failures: #{
          (number_of_iterations - success_count) / number_of_iterations * 100
        }%"
      )
    end)
  end
end
