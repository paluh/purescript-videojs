I. There are some compilation issues:

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
