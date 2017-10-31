#!/bin/bash

set -e # exit with nonzero exit code if anything fails


HASH=$(git rev-parse HEAD)
VERSION=$(python -c 'import sphinx; print sphinx.__version__')

echo "Starting to update gh-pages\n"

cd docs/_build/html
git init
git config user.name 'Clive Chan'
git config user.email 'cc@clive.io'
git remote add origin 'https://'${github_token}'@github.com/teamwaterloop/docs'
git fetch origin
git reset --soft origin/gh-pages
git add -A
git commit -m 'Travis deploy '${HASH:0:6}' with Sphinx '${VERSION}
git push -f origin master:gh-pages

echo "Done updating gh-pages\n"


