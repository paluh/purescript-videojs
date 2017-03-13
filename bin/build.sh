#!/bin/bash

babel ./src/VideojsPuxComponent.jsx > src/VideojsPuxComponent.js
if [ "$1" == "DEV" ]; then
  echo "Building webpack development builder..."
elif [ "$1" == "DLL" ]; then
  echo "Rebuilding developement dll..."
else
  echo "Building production bundle...";
fi

if [ "$1" == "DEV" ];
then
  DEBUG=purs-loader webpack --env.pux --env.simple --env.devel --watch --config webpack.config.js --progress
elif [ "$1" == "DLL" ]; then
  # pulp build
  DEBUG=purs-loader webpack --config webpack.dll.js
elif [ "$1" == "SNC" ]; then
  DEBUG=purs-loader webpack --env.production --env.snc --config webpack.config.js --progress
else
  DEBUG=purs-loader webpack --env.production --env.simple --config webpack.config.js --optimize-minimize
  DEBUG=purs-loader webpack --env.production --env.pux --config webpack.config.js --optimize-minimize
fi

# purs-loader.bundle = false
#     pux.bundle.js   1.3 MB       0  [emitted]  [big]  pux
#  simple.bundle.js   929 kB       1  [emitted]  [big]  simple

# purs-loader.bundle = true
#     pux.bundle.js   818 kB       1  [emitted]  [big]  pux
#  simple.bundle.js   818 kB       0  [emitted]  [big]  simple

# purs-loader.bundle = true, bundle-args: module: ...
#     pux.bundle.js   811 kB       0  [emitted]  [big]  pux
# simple.bundle.js    530 kB       0  [emitted]  [big]  simple


# --optimize-minimize # --profile  --display-chunks --display-reasons --display-error-details --display-modules

#&& gzip -f -k build/embed.min.js && cp build/embed.min.js.gz ~/programming/python/pnc/static/video/1.0/embed.min.js.gz && cp build/embed.min.js ~/programming/python/pnc/static/video/1.0/embed.min.js
