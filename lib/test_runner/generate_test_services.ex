defmodule Mix.Tasks.GenerateTestServices do
  use Mix.Task
  alias TestRunner.Versions

  @shortdoc "Generate docker-compose.override.yml"

  @impl Mix.Task
  def run(_) do
    versions = Versions.versions()

    volumes_text =
      versions
      |> Enum.map(fn {elixir_version, otp_version} ->
        "  build__#{elixir_version}_#{otp_version}:\n" <>
        "  deps__#{elixir_version}_#{otp_version}:"
      end)
      |> Enum.join("\n")

    services_text =
      versions
      |> Enum.map(fn {elixir_version, otp_version} ->
        "  test_#{elixir_version}_#{otp_version}:
    build:
      context: ./
      args: ['ELIXIR_VERSION=#{elixir_version}', 'OTP_VERSION=#{otp_version}']
    volumes:
    - .:/code
    - build__#{elixir_version}_#{otp_version}:/code/_build
    - deps__#{elixir_version}_#{otp_version}:/code/deps
    working_dir: /code
    command: tail -f /dev/null
    depends_on:
      - kafka1"
      end)
      |> Enum.join("\n\n")

    File.write(
      "docker-compose.override.yml",
      "version: '3.2'

volumes:
#{volumes_text}

services:
#{services_text}

"
    )

    IO.puts("Done.")
  end
end
