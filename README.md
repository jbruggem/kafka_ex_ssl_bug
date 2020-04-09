# KafkaEx SSL Bug

This repo publishes code to reproduce [ERL-1213](https://bugs.erlang.org/browse/ERL-1213)

See also:

* https://github.com/kafkaex/kafka_ex/issues/389
* https://github.com/kafkaex/kafka_ex/pull/386

Dependencies:

* docker
* docker-compose

## Run the test

The test simply consists in writing 2k messages to kafka, which involves ssl send/receive.

We test it with different version of OTP, but the same version of Elixir.

```bash
# Start the kafka server and a container per version we wish to test
docker-compose up -d

# Test with Elixir 1.9.4 and Erlang OTP 21.2
docker-compose exec test_v1.9.4_21.2 mix test

# Test with Elixir 1.9.4 and Erlang OTP 21.3
docker-compose exec test_v1.9.4_21.3 mix test

# Test with Elixir 1.9.4 and Erlang OTP 22.3
docker-compose exec test_v1.9.4_22.3 mix test
```

## Run many times

You can run these tests many times using:

```bash
mix run_all_tests
```

Here are the results when running them 20 times on many versions of OTP:

```bash
# elixir 1.9 - OTP 20
[{"v1.9.4", "20.3"}] Successes: 100.0% Failures: 0.0%

# elixir 1.9 - OTP 21
[{"v1.9.4", "21.1"}] Successes: 50.0% Failures: 50.0%
[{"v1.9.4", "21.2"}] Successes: 100.0% Failures: 0.0%
[{"v1.9.4", "21.3.1"}] Successes: 100.0% Failures: 0.0%
[{"v1.9.4", "21.3.3"}] Successes: 100.0% Failures: 0.0%
[{"v1.9.4", "21.3.5"}] Successes: 100.0% Failures: 0.0%
[{"v1.9.4", "21.3.7"}] Successes: 100.0% Failures: 0.0%

# elixir 1.9 - OTP 21.3.8
[{"v1.9.4", "21.3.8.1"}] Successes: 0.0% Failures: 100.0%
[{"v1.9.4", "21.3.8.7"}] Successes: 0.0% Failures: 100.0%
[{"v1.9.4", "21.3.8.14"}] Successes: 0.0% Failures: 100.0%

# elixir 1.9 - OTP 22
[{"v1.9.4", "22.1"}] Successes: 0.0% Failures: 100.0%
[{"v1.9.4", "22.2"}] Successes: 0.0% Failures: 100.0%
[{"v1.9.4", "22.3"}] Successes: 0.0% Failures: 100.0%

# elixir 1.10
[{"v1.10.2", "21.2"}] Successes: 100.0% Failures: 0.0%
[{"v1.10.2", "21.3"}] Successes: 0.0% Failures: 100.0%
[{"v1.10.2", "22.3"}] Successes: 0.0% Failures: 100.0%

# elixir 1.10 - OTP 23
[{"v1.10.2", "23.0-rc2"}] Successes: 0.0% Failures: 100.0%


```

## Add a new version to run the tests with

1. add version to `lib/test_runner/versions.ex`
2. re-generate the docker-compose override with `mix generate_docker_compose`
