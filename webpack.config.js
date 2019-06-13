'use strict';

const path = require('path');

module.exports = {
  mode: 'development',

  entry: {
    app: path.resolve(__dirname, 'src', 'js', 'index.js'),
  },

  output: {
    path: path.resolve(__dirname, "docs"),
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
      {
        test: /\.css$/,
        loader: [
          'style-loader',
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: [
                require('tailwindcss'),
                require('autoprefixer'),
              ],
            },
          },
        ],
      },
    ],
    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    stats: { colors: true },
  }
};
