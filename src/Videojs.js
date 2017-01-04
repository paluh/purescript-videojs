/* global exports */
"use strict";

// module Videojs

require('video.js');
require('videojs-playlist');
require('videojs-watermark');
require('videojs-quality-picker');
require('videojs5-hlsjs-source-handler');

if (typeof Array.prototype.forEach != 'function') {
    Array.prototype.forEach = function(callback){
      for (var i = 0; i < this.length; i++){
        callback.apply(this, [this[i], i, this]);
      }
    };
}

exports.videojsImpl = function(left, right, playerElementId, options) {
  return function() {
    var player, result;
    try {
      player = videojs(playerElementId, options);
      player.qualityPickerPlugin();
      if(options.watermark) {
        player.watermark({
          'image': options.watermark.url,
          'fadeOut': options.watermark.fadeOut,
          'position': options.watermark.position
        });
      }
      result = right(player);
    } catch(err) {
      result = left("videojs error: \n" + err);
    }
    return result;
  };
};

exports.playlistImpl = function(player, playlist) {
  return function() {
    player.playlist(playlist);
  };
};

exports.playlistItemImpl = function(player, index) {
  return function() {
    return player.currentItem(index);
  };
};
