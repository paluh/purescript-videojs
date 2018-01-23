/* global exports */
"use strict";

// module Videojs

var videojs = require('video.js');
require('videojs-playlist');
require('videojs-watermark');
require('videojs-quality-picker');

videojs.getComponent('Flash').prototype.play = function(){
  this.trigger('waiting');
  this.el_.vjs_load();
  this.el_.vjs_play();
};

videojs.getComponent('Flash').prototype.currentTime = function() {
  return 1;
};

videojs.getComponent('Flash').prototype.bufferedPercent = function() {
  return 1;
};

videojs.getComponent('Flash').streamToParts = function(src) {
  var parts = {
    connection: '',
    stream: ''
  }, rtmpParts;
  if (!src) { return parts; }
  rtmpParts = /(rtmp.*live\/)(.*)/.exec(src);
  if(rtmpParts) {
    parts.connection = rtmpParts[1];
    parts.stream = rtmpParts[2];
  } else {
    throw "Videojs.streamToParts: url doesn't match hardcoded pattern rtmp://.*/live/";
  }
  return parts;
};

exports["videojsImpl'"] = function(playerElementId, options) {
  var player;
  player = window.videojs(playerElementId, options);
  player.qualityPickerPlugin();
  return player;
};

exports.videojsImpl = function(left, right, playerElementId, options) {
  return function() {
    var result, player;
    try {
      player = window.videojs(playerElementId, options);
      player.qualityPickerPlugin();
      result = right(player);
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
