'use strict';

var BowerWebpackPlugin = require('bower-webpack-plugin');
var path = require('path');
var webpack = require('webpack');

var bowerWebpackPlugin = new BowerWebpackPlugin({moduleDirectories: ['./bower_components']});

module.exports = function(env) {
  var entries = {},
      pscBundleArgs = {};

  if(env.simple) {
    entries.simple = './examples/Simple';
    pscBundleArgs = {'module': 'Simple'};
  } else if(env.pux) {
    entries.pux = './examples/PuxComponentSimple';
    pscBundleArgs = {'module': 'PuxComponentSimple'};
  }
  if(env.simple && env.pux) {
    pscBundleArgs = {};
  }

  var r = {
    entry: entries,
      devtool: env.devel?'eval':'source-map',
      cache: true,
      devServer:
        { contentBase: '.',
          port: 9878,
          stats: 'errors-only',
          historyApiFallback: true,
        },
      output:
        { path: path.join(__dirname, './output'),
          pathinfo: true,
          library: '[name]',
          filename: '[name].bundle.js',
        },
      plugins: [
        bowerWebpackPlugin,
        new webpack.ProvidePlugin({'window.videojs': 'video.js', 'videojs': 'video.js'})
      ],
      module: {
        loaders: [{
           test: /\.purs$/,
              loader: "purs-loader",
              query: { src: [ 'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs', 'examples/**/*.purs'  ],
                       bundle: !env.devel,
                       bundleArgs: pscBundleArgs,
                       output: './output',
                       psc: 'psa',
                       pscIde: true,
                       pscIdeArgs: {'port': 4088},
                       pscArgs: env.devel?{'no-opts': true}:{'no-prefix': true},
                       watch: env.devel
                     }
            }, {
              test: /\.js$/,
              loader: 'babel-loader',
              exclude: [/hls.js/],
              query: { cacheDirectory: true }
            }, {
              test: /\.swf$/,
              loader: "file?name=[path][name].[ext]"
            }, {
              test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
              loader: "file-loader"
            }, {
              test: /\.css$/,
              loader: "style-loader!css-loader",
            }, {
              test: /\.scss$/,
              loader: "style-loader!css-loader!sass-loader"
            }]
      },
      resolve: {
        plugins: [bowerWebpackPlugin],
        modules: [
            'bower_components',
            'node_modules',
            'css'
        ],
        extensions: [ '.purs', '.js'],
        descriptionFiles: ['bower.json', 'package.json'],
        mainFields: ['main', 'browser']
      }


      //resolve:
      //  { modulesDirectories: [ 'node_modules', 'bower_components', 'css' ],
      //    extensions: [ '', '.purs', '.js']
      //  }
    };
    console.log(r);
    return r;
};
