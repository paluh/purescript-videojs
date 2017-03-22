/* global exports */
"use strict";

// module Videojs

require('video.js');
//require('videojs-errors');
require('videojs-playlist');
require('videojs-watermark');
require('videojs-quality-picker');
require('videojs5-hlsjs-source-handler');

videojs.getComponent('Flash').prototype.play = function(){
  this.trigger('waiting');
  this.el_.vjs_load();
  this.el_.vjs_play();
};

videojs.getComponent('Flash').streamToParts = function(src) {
  var parts = {
    connection: '',
    stream: ''
  }, rtmpParts;
  if (!src) {
    return parts;
  }
  rtmpParts = /(rtmp.*live\/)(.*)/.exec(src);
  parts.connection = rtmpParts[1];
  parts.stream = rtmpParts[2];
  return parts;
};


exports.playerInit = function(playerElementId, options) {
  var player;
  options.flash = {'swf': "//vjs.zencdn.net/swf/5.2.0/video-js.swf"};
  player = videojs(playerElementId, options);
  player.qualityPickerPlugin();
  //player.errors();
  return player;
};

exports.videojsImpl = function(left, right, playerElementId, options) {
  return function() {
    var result;
    try {
      result = right(exports.playerInit(playerElementId, options));
    } catch(err) {
      result = left("videojs error: \n" + err);
    }
    return result;
  };
};

exports.watermarkImpl = function(player, watermark) {
  return function() {
    if(watermark) {
      player.watermark(watermark);
    } else {
      player.watermark({});
    }
  };
};

exports.playlistImpl = function(player, playlist) {
  return function() {
    player.playlist(playlist);
  };
};

exports.playlistItemImpl = function(player, index) {
  return function() {
    return player.playlist.currentItem(index);
  };
};
