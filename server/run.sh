#!/bin/sh
export HOME=/root
export APP_ENV="production"
/usr/local/bin/sbcl \
        --noinform \
        --disable-debugger \
        --eval '(pushnew #P"/srv/aiwiki/" asdf:*central-registry*)' \
        --eval '(progn (ql:quickload :aiwiki) (ql:quickload :slynk))' \
        --eval '(progn (aiwiki:start :mode :production :address "127.0.0.1" :server :woo)
                (slynk:create-server :port 4005 :style :spawn :dont-close t))'