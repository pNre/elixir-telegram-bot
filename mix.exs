defmodule Rebot.Mixfile do
  use Mix.Project

  def project do
    [app: :rebot,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :nadia, :httpoison, :feeder_ex, :cowboy, :plug],
     mod: {Rebot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:nadia, "~> 0.4.2"},
     {:feeder_ex, "~> 0.0.5"},
     {:httpoison, "~> 0.10.0"},
     {:exconstructor, "~> 1.0.2"},
     {:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.3"}]
  end
end
