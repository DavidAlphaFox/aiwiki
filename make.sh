#!/bin/sh
rm -r ./dist
mkdir -p ./dist/aiwiki/admin
cd ./admin && yarn && yarn build && cd ..
cp -r ./admin/build/* ./dist/aiwiki/admin/
cp -r ./server/static/* ./dist/aiwiki/
cp -r ./server ./dist