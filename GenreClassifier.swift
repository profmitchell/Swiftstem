import Foundation
import CreateML
import CoreML

class GenreClassifier {
    static func trainModel(datasetPath: String, outputPath: String) throws {
        let datasetURL = URL(fileURLWithPath: datasetPath)
        let outputURL = URL(fileURLWithPath: outputPath)
        
        let audioData = try MLDataTable(contentsOf: datasetURL)
        
        let (trainingData, testingData) = audioData.randomSplit(by: 0.8)
        
        let classifier = try MLSoundClassifier(trainingData: trainingData,
                                               featureColumn: "audio",
                                               labelColumn: "label")
        
        let evaluation = classifier.evaluation(on: testingData)
        print("Evaluation metrics: \(evaluation)")
        
        try classifier.write(to: outputURL)
        print("Model saved to: \(outputURL.path)")
    }
}