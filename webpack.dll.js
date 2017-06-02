'use strict';

var BowerWebpackPlugin = require('bower-webpack-plugin');
var path = require('path');
var webpack = require('webpack');

var bowerWebpackPlugin = new BowerWebpackPlugin({moduleDirectories: ['./bower_components']});

module.exports = function() { // you can accept here 'env' argument
  var r = {
    entry: {
      'vendors': [path.join(__dirname, './src/vendors.js')]
    },
    devtool: 'source-map',
    output: {
      path: path.join(__dirname, './output'),
      pathinfo: true,
      library: '[name]',
      filename: '[name].dll.js',
    },
    plugins: [
      bowerWebpackPlugin,
      new webpack.DllPlugin({
          path: path.join(__dirname, './output', '[name].manifest.dll.json'),
          name: '[name]',
      }),
      new webpack.ProvidePlugin({'window.videojs': 'video.js', 'videojs': 'video.js'})
    ],
    module: {
      loaders: [{
         test: /\.purs$/,
            loader: "purs-loader",
            query: { src: [ 'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs', 'examples/**/*.purs'  ],
                     bundle: true,
                     output: './output',
                     psc: 'psa',
                     pscIde: true,
                     pscIdeArgs: {'port': 4088},
                   }
          }, {
            test: /\.js$/,
            loader: 'babel-loader',
            exclude: [/hls.js/, /streamroot-hlsjs-p2p-bundle/],
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
          'output',
          'bower_components',
          'node_modules',
          'css'
      ],
      extensions: [ '.purs', '.js'],
      descriptionFiles: ['bower.json', 'package.json'],
      mainFields: ['main', 'browser']
    }
  };
  console.log(r);
  return r;
};
