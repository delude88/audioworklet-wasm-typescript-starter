const path = require('path');

const workletPaths = [
    'src/worklets/my-audio-processor.ts'
]

const bundleWorklet = (workletPath) => {
    return {
        entry: path.resolve(__dirname,workletPath),
        module: {
            rules: [
                {
                    test: /\.tsx?$/,
                    use: 'ts-loader',
                    exclude: /node_modules/,
                },
            ],
        },
        resolve: {
            extensions: ['.ts', '.js'],
        },
        output: {
            filename: '[name].js',
            path: path.resolve(__dirname, 'public'),
        },
    }
}


module.exports = workletPaths.map(workletPath => bundleWorklet(workletPath));