#!/usr/bin/env bash
PORT=38990
DOMAIN=127.0.0.1 # videojs.localdomain
echo "\nserving index page on: $DOMAIN:$PORT\n\n"
python -m http.server --bind $DOMAIN $PORT
#echo "Visit: localhost:"$PORT"/index.html to test webpage"
#DEBUG="purs-loader" webpack-dev-server --hot --history-api-fallback --port $PORT 
