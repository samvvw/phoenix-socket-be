# Extend from the official Elixir image.
FROM elixir:latest

# Create app directory and copy the Elixir projects into it.

RUN apt-get update && \
    apt-get install -y postgresql-client

RUN apt-get install -y build-essential inotify-tools \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean 


WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV="dev"

COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY entrypoint.sh ./entrypoint.sh

RUN chmod +x /app/entrypoint.sh

EXPOSE 4000

CMD ["/app/entrypoint.sh"]