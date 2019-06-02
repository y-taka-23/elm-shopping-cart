'use strict';

const path = require('path');

module.exports = {
  mode: 'development',

  entry: {
    app: path.resolve(__dirname, 'src', 'js', 'index.js'),
  },

  output: {
    path: path.resolve(__dirname, "__build__"),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader?name=[name].[ext]',
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?verbose=true',
      },
    ],
    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    stats: { colors: true },
  }
};
