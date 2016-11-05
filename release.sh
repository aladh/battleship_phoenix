#!/usr/bin/env bash

git pull # Get latest code (dependencies: git, already cloned repo)

mix deps.get # Get all dependencies (prod + dev so version can be obtained) (dependencies: erlang, elixir)

npm install # Get js dependencies (dev for bruch and prod for assets) (dependencies: nodejs, npm)
brunch build --production # Compile static assets for prod (dependencies: brunch(globally installed))
MIX_ENV=prod mix phoenix.digest # Add digest to compiled assets

MIX_ENV=prod mix do compile, release # Compile and release

version=$(mix run -e 'IO.puts Mix.Project.config[:version]') # Get version
version=$(echo $version | grep -o '\S*$') # Ignore compile messages

echo "Upgrading to $version..."

mkdir "/var/www/battleship/releases/$version"
cp "rel/battleship/releases/$version/battleship.tar.gz" "/var/www/battleship/releases/$version/"
/var/www/battleship/bin/battleship upgrade "$version"
