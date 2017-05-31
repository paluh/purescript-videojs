'use strict';

var BowerWebpackPlugin = require('bower-webpack-plugin');
var path = require('path');
var webpack = require('webpack');


module.exports = function(env) {
  var entries = {},
      pscBundleArgs = {},
      libraryTarget = 'var',
      library = '[name]',
      externals = {},
      targetsCount = 0,
      bowerWebpackPlugin = new BowerWebpackPlugin({moduleDirectories: ['./bower_components']});

  if(env.simple) {
    targetsCount++;
    entries.simple = './examples/Simple';
    pscBundleArgs = {'module': 'Simple'};
  }
  if(env.streamrootSimple) {
    targetsCount++;
    entries.streamrootSimple = './examples/StreamrootSimple';
    pscBundleArgs = {'module': 'StreamrootSimple'};
  }
  if(env.pux) {
    targetsCount++;
    entries.pux = './examples/PuxComponent';
    pscBundleArgs = {'module': 'PuxComponent'};
  }
  if(env.streamrootPux) {
    targetsCount++;
    entries.streamrootPux = './examples/StreamrootPuxComponent';
    pscBundleArgs = {'module': 'StreamrootPuxComponent'};
  }
  if(targetsCount > 1) {
    throw {'message': 'Builing more then one target can lead to strange bundle generation!'};
  }
  if(targetsCount === 0) {
    throw {'message': 'You have to specify at exactly one target: env.simple, env.streamrootSimple, env.pux, env.streamrootPux!'};
  }

  var plugins = [
      bowerWebpackPlugin,
      new webpack.ProvidePlugin({
        'window.videojs': 'video.js',
        "window['videojs']": 'video.js',
        'global.videojs': 'video.js',
        "global['videojs']": 'video.js',
        'videojs': 'video.js'
      })
  ];

  if(env.devel) {
      plugins.push(
        new webpack.DllReferencePlugin({
            context: __dirname,
            manifest: require("./output/vendors.manifest.dll.json")
        })
      );
  }

  if(env.snc) {
    entries.snc = './examples/Snc';
    pscBundleArgs = {'module': 'Snc'};
    libraryTarget = 'amd';
    library = 'videoChat';
    externals.converse = 'converse';
    externals.jquery = 'jQuery';
  }

  var r = {
    entry: entries,
      devtool: env.devel?'eval':'cheap-module-source-map',
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
          library: library,
          libraryTarget: libraryTarget,
          filename: '[name].bundle.js',
        },
      plugins: plugins,
      module: {
        loaders: [{
           test: /\.purs$/,
              loader: "purs-loader",
              query: { src: [ 'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs', 'examples/**/*.purs'  ],
                       bundle: !env.devel && env.pursBundle,
                       bundleArgs: pscBundleArgs,
                       output: './output',
                       psc: 'psa',
                       pscIde: true,
                       pscIdeArgs: {'port': 4088},
                       pscArgs: env.devel?{}:{'no-prefix': true},
                       watch: env.devel
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
            }
        ]
      },
      externals: externals,
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
      },


      //resolve:
      //  { modulesDirectories: [ 'node_modules', 'bower_components', 'css' ],
      //    extensions: [ '', '.purs', '.js']
      //  }
    };
    console.log("Purs bundle: " + (!env.devel && env.pursBundle));
    console.log(r);
    return r;
};
