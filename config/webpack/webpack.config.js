const { generateWebpackConfig } = require('shakapacker')

const webpackConfig = generateWebpackConfig()

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
