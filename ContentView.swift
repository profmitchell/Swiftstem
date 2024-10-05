import SwiftUI
import AVFoundation
import CoreML

struct ContentView: View {
    @State private var selectedFile: URL?
    @State private var classificationResult: String = ""
    @State private var isClassifying = false
    
    var body: some View {
        VStack {
            Text("Genre Classifier")
                .font(.largeTitle)
            
            Button("Select Audio File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.canChooseFiles = true
                panel.allowedContentTypes = [.audio]
                
                if panel.runModal() == .OK {
                    self.selectedFile = panel.url
                }
            }
            
            if let selectedFile = selectedFile {
                Text("Selected file: \(selectedFile.lastPathComponent)")
            }
            
            Button("Classify Genre") {
                classifyGenre()
            }
            .disabled(selectedFile == nil || isClassifying)
            
            if isClassifying {
                ProgressView()
            }
            
            Text(classificationResult)
                .padding()
        }
        .padding()
    }
    
    func classifyGenre() {
        guard let audioURL = selectedFile else { return }
        isClassifying = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let config = MLModelConfiguration()
                let model = try GenreClassifierModel(configuration: config)
                
                let audioFile = try AVAudioFile(forReading: audioURL)
                let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
                try audioFile.read(into: audioBuffer!)
                
                let output = try model.prediction(audioSamples: audioBuffer!.floatChannelData![0])
                
                DispatchQueue.main.async {
                    self.classificationResult = "Genre: \(output.classLabel), Confidence: \(output.classLabelProbs[output.classLabel] ?? 0)"
                    self.isClassifying = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.classificationResult = "Classification failed: \(error.localizedDescription)"
                    self.isClassifying = false
                }
            }
        }
    }
}