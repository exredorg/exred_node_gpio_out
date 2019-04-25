defmodule Exred.Node.GPIOOut.Mixfile do
  use Mix.Project

  @description "Sends data to a RaspberryPi GPIO pin"
  @version File.read!("VERSION") |> String.trim()

  def project do
    [
      app: :exred_node_gpio_out,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exred_nodeprototype, "~> 0.2"},
      {:ex_doc, "~> 0.19.0", only: :dev, runtime: false},
      {:elixir_ale, "~> 1.0"},
      {:exred_nodetest, "~> 0.1.0", only: :test}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Zsolt Keszthelyi"],
      links: %{
        "GitHub" => "https://github.com/exredorg/exred_node_gpio_out.git",
        "Exred" => "http://exred.org"
      },
      files: ["lib", "mix.exs", "README.md", "LICENSE", "VERSION"]
    }
  end
end
