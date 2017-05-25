/* global exports */
"use strict";

var Videojs = require('../Videojs');

// module HlsjsSourceHandler

exports.videojsImpl = function(left, right, parentId, options) {
  require('videojs5-hlsjs-source-handler');
  return Videojs.videojsImpl(left, right, parentId, options);
};

exports["videojsImpl'"] = function(parentId, options) {
  require('videojs5-hlsjs-source-handler');
  return Videojs["videojsImpl'"](parentId, options);
};
