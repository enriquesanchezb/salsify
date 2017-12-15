defmodule Salsify.SlackBot do
  use Slack

  alias Salsify.{LoversAdapter, Parser}

  require Logger

  def handle_event(message = %{type: "message"}, slack, state) do
    Logger.debug("Handling message: #{inspect(message)}")
    case Parser.parse(message.text) do
      {:ok, loved} -> add_love(message.user, loved, message.channel, slack)
      _ -> :ok
    end
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def add_love(lover, loved, channel, slack) do
    Logger.info "Love request for users: #{lover}, #{loved}"
    {valid_love, message} = LoversAdapter.valid_love?(lover, loved, slack.me.id)
    if valid_love == :valid do
      add_relationship(lover, loved, channel, slack)
    else
      Logger.info("Invalid request: #{message}")
      send_message(message, channel, slack)
    end
    :ok
  end

  def add_relationship(lover, loved, channel, slack) do
    {result, message} = LoversAdapter.search_love(lover, loved)
    case result do
      :not_created ->
        create_new_love(lover, loved, channel, slack)
      :created ->
        if message == lover do
          send_message("Ya te habías apuntado pesado", channel, slack)
        else
          create_new_match(lover, loved, channel, slack)
        end
      :match ->
        send_message(message, channel, slack)
    end
    :ok
  end

  def create_new_love(lover, loved, channel, slack) do
    Logger.info('Creating new love for: #{lover} & #{loved}')
    LoversAdapter.create_relationship(lover, loved)

    Logger.debug('Open a new Instant Message for #{loved}')
    message = Slack.Web.Im.open("#{loved}", %{token: slack.token})
    send_message("Adivina a quién le gustas :smirk: :smirk:", message["channel"]["id"], slack)

    send_message("Apuntado :crossed_fingers:", channel, slack)
  end

  def create_new_match(lover, loved, channel, slack) do
    Logger.info('Creating new match for: #{lover} & #{loved}')
    LoversAdapter.update_relationship(lover, loved)

    Logger.debug("Open a new Private Group for #{lover} & #{loved}")
    message = Slack.Web.Mpim.open("#{slack.me.id}, #{lover}, #{loved}", %{token: slack.token})
    send_message(":heart: :heart: Tenemos un match!! :heart: :heart:", message["group"]["id"], slack)

    send_message(":heart: :heart: Tenemos un match!! :heart: :heart:", channel, slack)
  end
end
