/* global exports */
"use strict";

// module VideojsPuxComponent

const React = require('react');
// XXX: this import was to initialize videojs
//      but now we should pass videojs to constructor
// require('./Videojs');

let zip = (a1, a2) => a1.map((x, i) => [x, a2[i]]);

class VideoPlayer extends React.Component {
  // XXX: You have to initialize videojs before this
  constructor(props) {
    super(props);
  }
  componentWillReceiveProps(nextProps) {
    if(this.props.playlist.length !== nextProps.playlist.lenght ||
       this.props.playlist.poster !== nextProps.playlist.poster ||
       !zip(this.props.playlist.sources, nextProps.playlist.sources).every(([e1, e2]) => shallowEqual(e1, e2))) {
      this.player.playlist(nextProps.playlist);
    }

    if(this.props.playlistItem !== nextProps.playlistItem) {
      this.player.playlist.currentItem(nextProps.playlistItem);
    }

    if(!shallowEqual(this.props.watermark, nextProps.watermark)) {
      this.player.watermark(nextProps.watermark);
    }
  }
  shouldComponentUpdate() {
    return false;
  }
  componentDidMount() {
    // instantiate video.js
    this.player = this.props.videojs(this.videoNode, this.props.options);
    // this can be used to initialize signals...
    //  , function onPlayerReady() {
    //  console.log('onPlayerReady', this);
    //});
    this.player.qualityPickerPlugin();
    this.player.playlist(this.props.playlist);
    this.player.playlist.currentItem(this.props.playlistItem);
    this.player.watermark(this.props.watermark);
  }
  // destroy player on unmount
  componentWillUnmount() {
    if (this.player) {
      this.player.dispose();
    }
  }
  // wrap the player in a div with a `data-vjs-player` attribute
  // so videojs won't create additional wrapper in the DOM
  // see https://github.com/videojs/video.js/pull/3856
  render() {
    return (
      <div data-vjs-player>
        <video ref={ node => this.videoNode = node } className="video-js"></video>
      </div>
    )
  }
}
// var fromReact = function (comp) {
//   return function (attrs) {
//     return function (children) {
//       if (Array.isArray(children[0])) children = children[0];
// 
//       var props = attrs.reduce(function (obj, attr) {
//         var key = attr[0];
//         var val = attr[1];
//         obj[key] = val;
//         return obj;
//       }, {});
// 
//       return React.createElement.apply(null, [comp, props].concat(children))
//     };
//   };
// };

exports.videoPlayerComponentImpl = VideoPlayer
