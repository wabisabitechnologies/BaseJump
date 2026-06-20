var path = require("path");
var webpack = require("webpack");

var isProduction = process.env.NODE_ENV === 'production';

var plugins = [];
if (isProduction) {
  plugins.push(
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    })
  );
}

module.exports = {
  mode: isProduction ? 'production' : 'development',
  context: __dirname,
  entry: './frontend/basejump.jsx',
  output: {
    path: path.resolve(__dirname, 'public', 'assets'),
    filename: 'bundle.js',
    publicPath: '/assets/'
  },
  plugins: plugins,
  resolve: {
    extensions: ['.js', '.jsx', '.*']
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-react', '@babel/preset-env']
          }
        }
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader'],
      },
      {
        test: /\.less$/,
        use: ['style-loader', 'css-loader', 'less-loader'],
      },
      {
        test: /\.json$/,
        type: 'asset/resource', // replaces json-loader
      },
      {
        test: /\.(jpg|png|svg)$/,
        type: 'asset',
        parser: {
          dataUrlCondition: {
            maxSize: 25000,
          },
        },
      },
    ]
  },
  devtool: 'source-map',
};
