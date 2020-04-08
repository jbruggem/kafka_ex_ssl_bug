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
docker-compose exec test-21.2 mix test

# Test with Elixir 1.9.4 and Erlang OTP 21.3
docker-compose exec test-21.3 mix test

# Test with Elixir 1.9.4 and Erlang OTP 22.3
docker-compose exec test-22.3 mix test
```

## Run many times

You can run these three tests many times using:

```bash
elixir run_tests_many_times.exs
```

Here are the results when running them 50 times:

```bash
[21.2] Successes: 100.0% Failures: 0.0%
[21.3] Successes: 0.0% Failures: 100.0%
[22.3] Successes: 0.0% Failures: 100.0%
```
