I. Installation

    I was able to use purescript-videojs with minimal overhead:

    * copied webpack.config.json

    * copied .babelrc

    * added this line to app.js:

        require('purescript-videojs');

    * I still don't know if all plugins are working correctly (for example videojs-playlist)

II. To run pux related builds/examples you have to:

  npm install react@15.4.2 react-dom@15.4.2

III. Here you have old HOWTO


  There are some compilation issues:

  * change `bower_components/bower.json`:

      "main": [
        "dist/alt/video.novtt.js",
        "dist/video-js.css"
      ]

  * change `bower_components/videojs-playlist/bower.json`

      "main": [
        `dist/src/playlist.min.js`,
      ]

  * install global (fuck it)!:

      npm install global

  * copy webpack settings:

    - be careful to not compile hls.js second time with babel!



