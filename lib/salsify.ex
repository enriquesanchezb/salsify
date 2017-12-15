defmodule Salsify do
  use Application

  # :observer.start
  # c("lib/slack/slack.ex")

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:salsify, Salsify)[:token]

    repo = [Salsify.Repo]

    # Define workers and child supervisors to be supervised
    children =
      case Application.get_env(:salsify, :enable_salsify_worker, false) do
        true ->
          options = %{keepalive: 10000, name: :salsify_websocket}
          [worker(Slack.Bot, [Salsify.SlackBot, [], slack_token, options], [restart: :transient])] ++ repo
        false -> repo
      end


    opts = [strategy: :one_for_one, name: Salsify.Supervisor]
    Supervisor.start_link(children, opts)
  end
end