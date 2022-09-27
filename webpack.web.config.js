const path = require('path');

module.exports = {
    entry: path.resolve(__dirname, "src/web/index.ts"),
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.(js|jsx|tsx|ts)$/,
                exclude: /node_modules/,
                loader: 'babel-loader'
            }
        ]
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "index.js",
        libraryTarget: 'umd',
        umdNamedDefine: true
    },
}