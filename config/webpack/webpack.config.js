const { generateWebpackConfig } = require('shakapacker')

const webpackConfig = generateWebpackConfig()

// Ensure webpack never asks Node's OpenSSL 3 for md4 (unsupported since Node
// 17). Switching to xxhash64 keeps builds reproducible and avoids the
// "error:0308010C:digital envelope routines::unsupported" runtime crash.
webpackConfig.output = webpackConfig.output || {}
webpackConfig.output.hashFunction = 'xxhash64'

// Opt every sass-loader entry into the modern Sass API so we stop getting
// "The legacy JS API is deprecated and will be removed in Dart Sass 2.0.0"
// warnings on every build.
const patchSassLoader = (use) => {
  if (typeof use !== 'object' || !use.loader) return
  if (!use.loader.includes('sass-loader')) return

  const existing = use.options || {}
  const { sassOptions = {}, ...rest } = existing
  const { includePaths, ...sassRest } = sassOptions

  use.options = {
    ...rest,
    api: 'modern',
    sassOptions: {
      ...sassRest,
      ...(includePaths ? { loadPaths: includePaths } : {})
    }
  }
}

webpackConfig.module.rules.forEach((rule) => {
  if (Array.isArray(rule.use)) rule.use.forEach(patchSassLoader)
})

module.exports = webpackConfig
