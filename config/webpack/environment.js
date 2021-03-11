const { environment } = require('@rails/webpacker')
var webpack = require('webpack');

environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery',
        Popper: ['popper.js', 'default']
    })
)

environment.config.merge({
    performance: {
        maxAssetSize: 4000000,
        maxEntrypointSize: 4000000,
    }
})

module.exports = environment
