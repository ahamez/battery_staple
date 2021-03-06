ARG ELIXIR_VERSION=1.9.1-alpine
ARG ALPINE_VERSION=3.9

###################################################################

FROM elixir:${ELIXIR_VERSION} as build

# install build dependencies
RUN apk add --update git build-base nodejs npm

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force &&\
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod &&\
    mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build and release project
COPY priv priv
COPY lib lib
COPY dicts dicts
RUN mix compile &&\
    mix release

###################################################################

# # prepare release image
FROM alpine:${ALPINE_VERSION} AS app
RUN apk add --update bash

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/battery_staple ./
RUN chown -R nobody: /app
USER nobody

EXPOSE 4001

# docker run -p 4001:4001 -e SECRET_KEY_BASE=$(SECRET_KEY_BASE) battery_staple
# docker run -it -p 4001:4001 -e SECRET_KEY_BASE=$(SECRET_KEY_BASE) battery_staple start_iex
ENTRYPOINT ["./bin/battery_staple"]
CMD ["start"]
