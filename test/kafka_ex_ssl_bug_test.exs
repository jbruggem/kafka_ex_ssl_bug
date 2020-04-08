defmodule KafkaExSslBugTest do
  use ExUnit.Case
  doctest KafkaExSslBug
  alias KafkaEx.Protocol, as: Proto

  test "produce many messages with an acq required" do
    for index <- 0..2_000 do
      if rem(index, 50) == 0 do
        IO.write("#{index}, ")
      end

      produce =
        KafkaEx.produce(%Proto.Produce.Request{
          topic: "food",
          partition: 0,
          required_acks: 1,
          messages: [%Proto.Produce.Message{value: "hey_#{index}"}]
        })

      case produce do
        {:ok, _offset} -> :ok
        reply -> raise "Test failed while producing message #{index}: #{inspect(reply)}"
      end
    end
  end
end
