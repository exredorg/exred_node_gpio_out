defmodule Exred.Node.GPIOOut do
  @moduledoc """
  Sends data to a GPIO pin.

  Uses [Elixir ALE](https://github.com/fhunleth/elixir_ale) to interface with GPIO.

  ##Incoming Message format

    msg = %{payload :: 0 | 1 | true | false}

  ##Outgoing Message format

    msg = %{
      payload :: :ok | :error,
      error :: term
    }

  """

  @name "GPIO Out"
  @category "output"
  @info @moduledoc
  @config %{
    name: %{
      info: "Visible node name",
      value: @name,
      type: "string",
      attrs: %{max: 20}
    },
    pin_number: %{
      info: "GPIO pin number the node will write to",
      value: 0,
      type: "number",
      attrs: %{min: 0}
    }
  }
  @ui_attributes %{
    fire_button: false,
    right_icon: "send",
    config_order: [:name, :pin_number]
  }

  use Exred.NodePrototype
  alias ElixirALE.GPIO
  require Logger

  @impl true
  def node_init(state) do
    GenServer.cast(self(), :do_init)
    Map.put(state, :init, :starting)
  end

  @impl true
  def handle_cast(:do_init, %{init: :starting} = state) do
    # start GPIO process
    {:ok, pid} = GPIO.start_link(state.config.pin_number.value, :output)

    new_state =
      state
      |> Map.put(:pid, pid)
      |> Map.put(:init, :done)

    {:noreply, new_state}
  end

  @impl true
  def handle_msg(msg, %{init: :starting} = state) do
    Logger.warn(
      "UNHANDLED MSG DURING INIT node: #{state.node_id} #{get_in(state.config, [:name, :value])} msg: #{
        inspect(msg)
      }"
    )

    {nil, state}
  end

  def handle_msg(msg, %{init: :done} = state) do
    msg_out =
      case GPIO.write(state.pid, msg.payload) do
        :ok ->
          %{msg | payload: :ok}

        {:error, error} ->
          # put the error info in the outgoing msg
          %{msg | payload: :error} |> Map.put(:error, error)
      end

    {msg_out, state}
  end
end
