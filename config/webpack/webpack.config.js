const { generateWebpackConfig } = require('shakapacker')

const webpackConfig = generateWebpackConfig()

// Ensure webpack never asks Node's OpenSSL 3 for md4 (unsupported since Node
// 17). Switching to xxhash64 keeps builds reproducible and avoids the
// "error:0308010C:digital envelope routines::unsupported" runtime crash.
webpackConfig.output = webpackConfig.output || {}
webpackConfig.output.hashFunction = 'xxhash64'

module.exports = webpackConfig
