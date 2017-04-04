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
      bowerWebpackPlugin = new BowerWebpackPlugin({moduleDirectories: ['./bower_components']});

  if(env.simple) {
    entries.simple = './examples/Simple';
    pscBundleArgs = {'module': 'Simple'};
  }
  if(env.pux) {
    entries.pux = './examples/PuxComponentSimple';
    pscBundleArgs = {'module': 'PuxComponentSimple'};
  }
  if(env.simple && env.pux) {
    pscBundleArgs = {};
  }

  var plugins = [
      bowerWebpackPlugin,
      new webpack.ProvidePlugin({'window.videojs': 'video.js', 'videojs': 'video.js'})
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
      }


      //resolve:
      //  { modulesDirectories: [ 'node_modules', 'bower_components', 'css' ],
      //    extensions: [ '', '.purs', '.js']
      //  }
    };
    console.log(r);
    return r;
};
