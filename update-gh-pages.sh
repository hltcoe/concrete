#!/usr/bin/env sh

set -e

STARTDIR=$(pwd)
git remote add github git@github.com:hltcoe/concrete.git
git fetch github
git checkout -b gh-pages github/gh-pages
cd doc
sh regenerate_docs.sh $(which thrift) || $(echo "No thrift found."; exit 2)
mv schema/* $STARTDIR/
cd $STARTDIR
git commit . -m "update gh-pages"
git push github gh-pages || $(echo "Push failed, check ssh key/rights?"; exit 1)
