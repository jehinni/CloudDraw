#!/bin/bash

set -e

##
## Check if master is checked out
##

if ! git branch | grep "* master" -q; then
    echo "ERROR: YOU ARE NOT ON MASTER BRANCH"
    echo "Please checkout master and make sure you have push rights for origin."
    exit 1
fi

git reset HEAD .

##
## Get current version
##

VERSION=$(cat PeersGameDraw.podspec | sed -En 's/^\s*.*spec\.version.*=.*([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')

##
## Increment to a new version (e.g. "0.0.1" gets "0.0.2")
##

NEW_VERSION=`echo $VERSION | perl -pe 's/^((\d+\.)*)(\d+)(.*)$/$1.($3+1).$4/e'`

read -p "Changing version $VERSION to $NEW_VERSION. Ok? (y|N) " choice
case "$choice" in
  y|Y ) echo "I will make a version bump and push the new git tag now.";;
  n|N ) echo "Aborting..." && exit;;
  * ) echo "Invalid input, aborting..." && exit;;
esac

##
## Setting the new version in necessary files
##

sed -i '' -E "s/(spec\.version.*=.*\")$VERSION\"/\1$NEW_VERSION\"/g" PeersGameDraw.podspec
sed -i '' -E "s/(<string>)$VERSION(<\/string>)/\1$NEW_VERSION\2/g" PeersGameDraw/Info.plist

##
## Git Commit
##

git add PeersGameDraw.podspec PeersGameDraw/Info.plist
git commit -m "Increment version to $NEW_VERSION"

##
## Creating a git tag
##

git tag $NEW_VERSION

##
## Pushing the version bump and the git tag
##

git push origin
git push origin $NEW_VERSION

##
## Push to Spec Repo
##

pod repo push peers-specs PeersGameDraw.podspec \
    --sources='git@gitlab.mi.hdm-stuttgart.de:peers/specs.git,master' \
    --allow-warnings

