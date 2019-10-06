#!/bin/sh
rm -r ./dist
rm dist.tar.gz
mkdir -p ./dist/static/app/admin
cd ./admin && yarn && yarn build && cd ..
cp -r ./admin/build/* ./dist/static/app/admin/
cp -r ./server/static/* ./dist/static/app
cp -r ./server ./dist/aiwiki
tar -czf dist.tar.gz ./dist
