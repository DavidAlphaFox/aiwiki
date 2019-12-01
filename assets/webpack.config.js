const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
module.exports = {
  entry: './src/styles.css',
  module: {
    rules: [
      {
        test: /\.css$/,
        use:  [
        MiniCssExtractPlugin.loader,
        "css-loader", "postcss-loader",
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // all options are optional
      filename: '../../public/css/styles.css',
      chunkFilename: '../../public/css/styles.css',
      ignoreOrder: false, // Enable to remove warnings about conflicting order
    }),
  ],
  /*
  optimization: {
    minimizer: [ new OptimizeCSSAssetsPlugin({})],
  },*/
}
