process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

const config = environment.toWebpackConfig()

// webpack-dev-server 4.x does not support [contenthash] in dev mode
config.output.filename = 'js/[name].js'

module.exports = config
