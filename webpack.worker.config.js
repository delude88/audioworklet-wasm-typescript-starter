const path = require('path');

const worker = []
const worklets = [
    'src/worklets/my-audio-processor.ts'
]

const getFilename = (filepath) => path.parse(filepath).name

const bundleWorker = (worklet) => {
    return {
        entry: path.resolve(__dirname, worklet),
        module: {
            rules: [
                {
                    test: /\.(js|jsx|tsx|ts)$/,
                    exclude: /node_modules/,
                    loader: 'babel-loader'
                }
            ],
        },
        resolve: {
            extensions: ['.ts', '.js'],
        },
        output: {
            filename: `${getFilename(worklet)}.js`,
            path: path.resolve(__dirname, 'public'),
        },
        performance: {
            maxAssetSize: 50000,
            maxEntrypointSize: 50000,
        }
    }
}

module.exports = [...worklets, ...worker].map(worker => bundleWorker(worker));