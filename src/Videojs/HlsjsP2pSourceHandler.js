/* global exports */
"use strict";

var Videojs = require('../Videojs');

// module HlsjsP2pSourceHandler

exports.videojsImpl = function(left, right, parentId, options) {
  require('videojs5-hlsjs-p2p-source-handler');
  return Videojs.videojsImpl(left, right, parentId, options);
};

exports["videojsImpl'"] = function(parentId, options) {
  require('videojs5-hlsjs-p2p-source-handler');
  return Videojs["videojsImpl'"](parentId, options);
};
