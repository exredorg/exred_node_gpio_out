defmodule Exred.Node.GPIOOutTest do
  use ExUnit.Case
  doctest Exred.Node.GPIOOut
  require Logger

  use Exred.NodeTest, module: Exred.Node.GPIOOut

  setup_all do
    start_node()
  end

  test "has attributes" do
    assert is_map(Exred.Node.GPIOOut.attributes())
  end

  test "starts up then crashes on host without GPIO", context do
    :timer.sleep(2000)

    if Process.alive?(context.pid) do
      node_state2 = Exred.Node.GPIOOut.get_state(context.pid)

      Logger.warn("state after 2s (process was supposed to be dead): #{inspect(node_state2)}")
    end

    assert Process.alive?(context.pid) == false
  end
end
