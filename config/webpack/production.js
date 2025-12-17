process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const webpackConfig = require('./base')

// In production we want packs served from this app's origin.
// If the manifest contains protocol-relative URLs like `//packs/...`,
// browsers will request `https://packs/...` (wrong host) and CSS/JS won't load.
webpackConfig.output = webpackConfig.output || {}
webpackConfig.output.publicPath = '/packs/'

module.exports = webpackConfig
