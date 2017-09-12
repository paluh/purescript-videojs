I. Compilation

  * there is something wrong with "pux/.babelrc" which causes problems with module-loader - investigate further

  * in `bower_components/videojs-playlist/bower.json` change `"main": "src/js/index.js"`,

  * in `bower_components/videojs5-hlsjs-p2p-source-handler/bower.json` change

    from "main": "./dist/videojs5-hlsjs-p2p-source-handler.js"

    to "main": "./videojs5-hlsjs-p2p-source-handler.js",


  * If you get sass related error (not for linux platform etc.) run:

    $ npm rebuild node-sass

  * install `bower-npm-resolver` and `global` (just use `npm install`)

  * create ~/.bowerrc:

    {
      "resolvers": [
        "bower-npm-resolver"
      ]
    }

  * be careful to not compile hls.js second time with babel - use:

  { test: /\.js$/,
    exclude: [/hls.js/, /streamroot-hlsjs-p2p-bundle/],
    ..
  }

II. Hacking

1. Flash

To hack/fix flash player issue we want to make `FCSubscribe` call optional. It would be also cool if we could hide progress bar. Anyway to compile videojs-swf project run: grunt dist. To test it in browser change flash config in `src/Videojs.purs`.


III. Issues

  * it is REALLY IMPORTANT to only import and use appropriate version of videojs hlsjs source handler in your purescript code. If you use both versions in code they will be used in bundle...

  * remove videojs-hlsjs-source-handler and videojs5-hlsjs-p2p-source-handler from dev dll build (vendors.js)

  * You can't mix two bundles with different strategies on one page as streamroot provider will be placed in both

  * You can't use two streamroot bundle on single page!



IV. Installation as dependency

  I was able to use purescript-videojs with minimal overhead:

  * copied webpack.config.json

  * copied .babelrc

  * added this line to app.js:

      require('purescript-videojs');

  * I still don't know if all plugins are working correctly (for example videojs-playlist)


  * npm install react@15.4.2 react-dom@15.4.2

