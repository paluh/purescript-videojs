'use strict';

var webpack = require('webpack');
var BowerWebpackPlugin = require('bower-webpack-plugin');

var config
  = { entry: './app',
      devtool: 'source-map',
      debug: true,
      devServer:
        { contentBase: '.',
          port: 9878,
          stats: 'errors-only',
          historyApiFallback: true,
        },
      output:
        { path: __dirname,
          pathinfo: true,
          filename: 'bundle.js',
        },
      plugins:
        [ new BowerWebpackPlugin(),
          new webpack.ProvidePlugin({'window.videojs': 'video.js', 'videojs': 'video.js'})
        ],
      module: {
        loaders: [{
           test: /\.purs$/,
              loader: "purs-loader",
              query: { src: [ 'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs' ],
                       bundle: false,
                       output: './output',
                       psc: 'psa',
                       pscIde: true,
                       pscIdeArgs: {'port': 4088}
                     }
            }, {
              test: /\.js$/,
              loader: 'babel',
              exclude: [/hls.js/],
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
      resolve:
        { modulesDirectories: [ 'node_modules', 'bower_components', 'css' ],
          extensions: [ '', '.purs', '.js']
        }
    };

module.exports = config;
