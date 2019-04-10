FROM elixir:1.6-alpine as build

RUN apk add --no-cache nodejs yarn

WORKDIR /usr/src/app

COPY . .

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

RUN yarn && \
    ./node_modules/.bin/brunch build --production

ENV MIX_ENV=prod

RUN mix phoenix.digest && \
    mix release && \
    mkdir ../release && \
    cp _build/prod/rel/battleship/releases/1.0.0/battleship.tar.gz ../release && \
    cd ../release && \
    tar -xzf battleship.tar.gz && \
    rm battleship.tar.gz

FROM alpine:3.9

RUN apk add --no-cache bash openssl

WORKDIR /usr/src/app

COPY --from=build /usr/src/release .

EXPOSE 8888

CMD ["/usr/src/app/bin/battleship", "foreground"]