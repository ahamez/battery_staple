FROM elixir:1.9.1-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
COPY en_basic.txt en_basic.txt
RUN mix compile

# build release
RUN mix release

# # prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/battery_staple ./app
RUN chown -R nobody: /app
USER nobody

CMD ["./app/bin/battery_staple", "start"]
# docker run -p 4001:4001 -e SECRET_KEY_BASE battery-staple
