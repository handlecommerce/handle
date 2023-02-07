FROM elixir:1.14

# Install the latest Node 19
RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt install -y nodejs postgresql-client inotify-tools

RUN mix local.rebar --force \
 && mix local.hex --force

WORKDIR /workspace
