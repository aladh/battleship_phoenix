#!/usr/bin/env bash

git pull # Get latest code (dependencies: git, already cloned repo)

npm install # Get js dependencies (dev for bruch and prod for assets) (dependencies: nodejs, npm)
brunch build --production # Compile static assets for prod (dependencies: brunch(globally installed))
MIX_ENV=prod mix phoenix.digest # Add digest to compiled assets

mix deps.get # Get dependencies (dependencies: erlang, elixir)
MIX_ENV=prod mix do compile, release # Compile and release

version=$(mix run -e 'IO.puts Mix.Project.config[:version]')
echo "Upgrading to $version..."

mkdir "/var/www/battleship/releases/$version"
cp "rel/battleship/releases/$version/battleship.tar.gz" "/var/www/battleship/releases/$version/"
/var/www/battleship/bin/battleship upgrade "$version"
