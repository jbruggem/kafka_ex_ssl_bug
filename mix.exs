defmodule KafkaExSslBug.MixProject do
  use Mix.Project

  def project do
    [
      app: :kafka_ex_ssl_bug,
      version: "0.1.0",
      elixir: "~> 1.9.4",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :kafka_ex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kafka_ex, git: "https://github.com/kafkaex/kafka_ex.git", commit: "aaa0aa4bb33dab4267d48a9e1cf48da45d07f2dc"}
    ]
  end
end
