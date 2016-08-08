#!/usr/bin/env bash

read -p "What is the version? " -n 5 -r
echo
if [[ $REPLY ]]
then
  git pull # Get latest code (dependencies: git, already cloned repo)

  npm install # Get js dependencies (dev for bruch and prod for assets) (dependencies: nodejs, npm)
  brunch build --production # Compile static assets for prod (dependencies: brunch(globally installed))
  MIX_ENV=prod mix phoenix.digest # Add digest to compiled assets

  mix deps.get --only prod # Get prod dependencies (dependencies: erlang, elixir)
  MIX_ENV=prod mix do compile, release # Compile and release

  mkdir "/var/www/battleship/releases/$REPLY"
  cp "rel/battleship/releases/$REPLY/battleship.tar.gz" "/var/www/battleship/releases/$REPLY/"
  /var/www/battleship/bin/battleship upgrade "$REPLY"
fi
