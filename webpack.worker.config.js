const path = require('path');

const worker = []
const worklets = [
    'src/worklets/my-audio-processor.ts'
]

const getFilename = (filepath) => path.parse(filepath).name

const config = {
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
    performance: {
        maxAssetSize: 500000,
        maxEntrypointSize: 500000
    }
}

const bundleWorklet = (worklet) => {
    return {
        ...config,
        entry: path.resolve(__dirname, worklet),
        output: {
            filename: `${getFilename(worklet)}.js`,
            path: path.resolve(__dirname, 'public/worklets'),
        },
    }
}

const bundleWorker = (worklet) => {
    return {
        ...config,
        entry: path.resolve(__dirname, worklet),
        output: {
            filename: `${getFilename(worklet)}.js`,
            path: path.resolve(__dirname, 'public/worker'),
        }
    }
}

module.exports = [...worklets.map(worklet => bundleWorklet(worklet)), ...worker.map(worker => bundleWorker(worker))];
