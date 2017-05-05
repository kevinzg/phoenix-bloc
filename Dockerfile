FROM elixir:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y -q \
  nodejs \
  inotify-tools

WORKDIR /app
