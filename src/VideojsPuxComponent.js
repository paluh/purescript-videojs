'use strict';

var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

require('video.js');
require('videojs-playlist');
require('videojs-watermark');
require('videojs-quality-picker');
require('videojs5-hlsjs-source-handler');
var React = require('react');

videojs.getComponent('Flash').prototype.play = function () {
  this.el_.vjs_load();
  this.el_.vjs_play();
};

videojs.getComponent('Flash').streamToParts = function (src) {
  var parts = {
    connection: '',
    stream: ''
  },
      rtmpParts;
  if (!src) {
    return parts;
  }
  rtmpParts = /(rtmp.*live\/)(.*)/.exec(src);
  parts.connection = rtmpParts[1];
  parts.stream = rtmpParts[2];
  return parts;
};

var zip = function zip(a1, a2) {
  return a1.map(function (x, i) {
    return [x, a2[i]];
  });
};

var VideoPlayer = function (_React$Component) {
  _inherits(VideoPlayer, _React$Component);

  function VideoPlayer(props) {
    _classCallCheck(this, VideoPlayer);

    return _possibleConstructorReturn(this, (VideoPlayer.__proto__ || Object.getPrototypeOf(VideoPlayer)).call(this, props));
  }

  _createClass(VideoPlayer, [{
    key: 'componentWillReceiveProps',
    value: function componentWillReceiveProps(nextProps) {
      if (this.props.playlist.length !== nextProps.playlist.lenght || this.props.playlist.poster !== nextProps.playlist.poster || !zip(this.props.playlist.sources, nextProps.playlist.sources).every(function (_ref) {
        var _ref2 = _slicedToArray(_ref, 2),
            e1 = _ref2[0],
            e2 = _ref2[1];

        return shallowEqual(e1, e2);
      })) {
        this.player.playlist(nextProps.playlist);
      }

      if (this.props.playlistItem !== nextProps.playlistItem) {
        this.player.playlist.currentItem(nextProps.playlistItem);
      }

      if (!shallowEqual(this.props.watermark, nextProps.watermark)) {
        this.player.watermark(nextProps.watermark);
      }
    }
  }, {
    key: 'shouldComponentUpdate',
    value: function shouldComponentUpdate() {
      return false;
    }
  }, {
    key: 'componentDidMount',
    value: function componentDidMount() {
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

  }, {
    key: 'componentWillUnmount',
    value: function componentWillUnmount() {
      if (this.player) {
        this.player.dispose();
      }
    }
    // wrap the player in a div with a `data-vjs-player` attribute
    // so videojs won't create additional wrapper in the DOM
    // see https://github.com/videojs/video.js/pull/3856

  }, {
    key: 'render',
    value: function render() {
      var _this2 = this;

      return React.createElement(
        'div',
        { 'data-vjs-player': true },
        React.createElement('video', { ref: function ref(node) {
            return _this2.videoNode = node;
          }, className: 'video-js' })
      );
    }
  }]);

  return VideoPlayer;
}(React.Component);

var fromReact = function fromReact(comp) {
  return function (attrs) {
    return function (children) {
      if (Array.isArray(children[0])) children = children[0];

      var props = attrs.reduce(function (obj, attr) {
        var key = attr[0];
        var val = attr[1];
        obj[key] = val;
        return obj;
      }, {});

      return React.createElement.apply(null, [comp, props].concat(children));
    };
  };
};

exports.videoPlayer = VideoPlayer;
exports.videoPlayerComponentImpl = fromReact(VideoPlayer);

