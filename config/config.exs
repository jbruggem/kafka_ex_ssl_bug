import Config

config :kafka_ex,
  brokers: [{"kafka1", 9092}],
  use_ssl: true,
  ssl_options: [
    cacertfile: File.cwd!() <> "/ssl/ca-cert",
    certfile: File.cwd!() <> "/ssl/cert.pem",
    keyfile: File.cwd!() <> "/ssl/key.pem"
  ],
  kafka_version: "0.10.1"
