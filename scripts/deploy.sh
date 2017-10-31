#!/bin/bash

set -e # exit with nonzero exit code if anything fails

if [[ $TRAVIS_BRANCH == "master" && $TRAVIS_PULL_REQUEST == "false" ]]; then

HASH=$(git rev-parse HEAD)
VERSION=$(python -c 'import sphinx; print sphinx.__version__')

echo "Starting to update gh-pages\n"

#copy data we're interested in to other place
cp -R _build/html $HOME/dist

#go to home and setup git
cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

#using token clone gh-pages branch
git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git gh-pages > /dev/null

#go into directory and copy data we're interested in to that directory
cd gh-pages
cp -Rf $HOME/dist/* .

echo "Allow files with underscore https://help.github.com/articles/files-that-start-with-an-underscore-are-missing/" > .nojekyll

#add, commit and push files
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER deploying '${HASH:0:7}' with Sphinx '${VERSION:16}'"
git push -fq origin gh-pages > /dev/null

echo "Done updating gh-pages\n"

else
 echo "Skipped updating gh-pages, because build is not triggered from the master branch."
fi
