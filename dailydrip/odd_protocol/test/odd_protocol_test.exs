defprotocol Odd do
  @fallback_to_any true

  @doc "returns true if data is considered odd"
  def odd?(data)
end


defimpl Odd, for: Any do
  def odd?(_), do: false
end

defimpl Odd, for: Integer do
  require Integer
  def odd?(data) do
    Integer.is_odd(data)
  end
end

defimpl Odd, for: Float do
  def odd?(data) do
    Float.floor(data)
    |> trunc
    |> Odd.odd?
  end
end

defimpl Odd, for: List do
  def odd?(data) do
    Odd.odd?(Enum.count(data))
  end
end

defmodule Animal do
  defstruct hairy: false, leg_count: 4

  defimpl Odd, for: Animal do
    def odd?(%Animal{hairy: true}), do: true
    def odd?(_), do: false
  end
end





defmodule OddProtocolTest do
  use ExUnit.Case
  
  test "integers know if they're odd" do
    assert Odd.odd?(1)
    refute Odd.odd?(2)
  end

  test "floats are odd if their floor is" do
    assert Odd.odd?(1.1)
    assert Odd.odd?(1.9)
    refute Odd.odd?(2.1)
  end

  test "lists are odd based on their element count" do
    refute Odd.odd?([])
    assert Odd.odd?([1])
  end

  test "animals are odd if they're hairy" do
    assert Odd.odd?(%Animal{hairy: true})
    refute Odd.odd?(%Animal{hairy: false})
  end

  test "unspecified things aren't odd" do
    refute Odd.odd?(%{})
    refute Odd.odd?("jabow")
    refute Odd.odd?(:poland)
  end
end
