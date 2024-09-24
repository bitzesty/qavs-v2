const { webpackConfig, merge } = require('@rails/webpacker')
const customConfig = {
  resolve: {
    extensions: ['.css', '.scss']
  },
  devServer: {
    client: {
      overlay: false,
    },
  }
}

module.exports = merge(webpackConfig, customConfig)
