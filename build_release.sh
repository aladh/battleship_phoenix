#!/usr/bin/env bash

read -p "Did you bump the version? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  git pull # Get latest code (dependencies: git, already cloned repo)

  mix deps.get --only prod # Get prod dependencies (dependencies: erlang, elixir)
  MIX_ENV=prod mix compile # Compile code

  npm install # Get js dependencies (dev for bruch and prod for assets) (dependencies: nodejs, npm)
  brunch build --production # Compile static assets for prod (dependencies: brunch(globally installed))
  MIX_ENV=prod mix phoenix.digest # Add digest to compiled assets

  MIX_ENV=prod mix release # Generate release
fi

# mkdir /var/www/battleship/releases/0.0.9
# cp rel/battleship/releases/0.0.9/battleship.tar.gz /var/www/battleship/releases/0.0.9/
# /var/www/battleship/bin/battleship upgrade "0.0.9"
