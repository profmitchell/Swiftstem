import Foundation

let datasetPath = "/path/to/your/MusicDataset"
let outputPath = "/path/to/save/GenreClassifierModel.mlmodel"

do {
    try GenreClassifier.trainModel(datasetPath: datasetPath, outputPath: outputPath)
    print("Model training completed successfully!")
} catch {
    print("Error training model: \(error)")
}