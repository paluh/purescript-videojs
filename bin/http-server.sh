#!/bin/bash
PORT=38990
echo "\nserving index page on: localhost:$PORT\n\n"
python -m http.server $PORT
#echo "Visit: localhost:"$PORT"/index.html to test webpage"
#DEBUG="purs-loader" webpack-dev-server --hot --history-api-fallback --port $PORT 
