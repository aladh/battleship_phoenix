#!/bin/bash

git pull

mix deps.get --only prod
MIX_ENV=prod mix compile

brunch build --production
MIX_ENV=prod mix phoenix.digest

MIX_ENV=prod mix release
