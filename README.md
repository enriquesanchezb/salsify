# Salsify

Slack bot similar to Tinder. If two users likes each other, the bot will open a new private conversation between them.

## How it works

Add your `SLACK_API_TOKEN` to your environment variables (you can use an `.ENV` file)

```bash
# Install dependencies
mix deps.get

# Create database
mix ecto.create

# Execute Salsify
mix run --no-halt
```

### Commands

#### Me gusta
```
@salsibot me gusta @<name_of_your_loved_one>
```

## Tests

There are some tests... you can run them in this way:

```bash
MIX_ENV=test mix ecto.create
MIX_ENV=test mix test
```
