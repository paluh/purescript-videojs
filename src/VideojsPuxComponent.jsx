require('video.js');
require('videojs-playlist');
require('videojs-watermark');
require('videojs-quality-picker');
require('videojs5-hlsjs-source-handler');
const React = require('react');

videojs.getComponent('Flash').prototype.play = function(){
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

let zip = (a1, a2) => a1.map((x, i) => [x, a2[i]]);

class VideoPlayer extends React.Component {
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
    this.player = videojs(this.videoNode, this.props.options, function onPlayerReady() {
      console.log('onPlayerReady', this);
    });
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
var fromReact = function (comp) {
  return function (attrs) {
    return function (children) {
      if (Array.isArray(children[0])) children = children[0];

      var props = attrs.reduce(function (obj, attr) {
        var key = attr[0];
        var val = attr[1];
        obj[key] = val;
        return obj;
      }, {});

      return React.createElement.apply(null, [comp, props].concat(children))
    };
  };
};

exports.videoPlayer = VideoPlayer;
exports.videoPlayerComponentImpl = fromReact(VideoPlayer)
