//
//  CardReaderView.swift
//  CardReadingComponents
//
//  Created by Calvin Chestnut on 8/20/24.
//

import SwiftUI
import Vision
import VisionKit

typealias CardReaderResult = (stateID: CardScanResultModel?, medicalID: CardScanResultModel?)
typealias CardReaderCompletion = ((CardReaderResult) -> Void)

struct CardReaderView: View {
    
    @State
    var presentingCapture: Bool = false
    @State
    var presentingFinish: Bool = false
    @State
    var presentingConfirm: Bool = false
    
    // Migrate to DataState ideally
    @State
    var stateResult: CardScanResultModel?
    @State
    var medicalResult: CardScanResultModel?
    
    @State
    var finishModel: CardScanResultModel?
    
    private let completion: CardReaderCompletion
    
    init(completion: @escaping CardReaderCompletion) {
        self.completion = completion
    }
    
    var body: some View {
        appropriateStateView
            .presentationDetents([.medium])
            .sheet(isPresented: $presentingCapture, content: { deviceAppropriateCaptureView })
            .sheet(item: $finishModel) { model in
                completeFormView(with: $finishModel)
            }
    }
    
    @ViewBuilder
    var appropriateStateView: some View {
        if (stateResult != nil || medicalResult != nil) && (stateResult?.isComplete ?? true && medicalResult?.isComplete ?? true) {
            VStack {
                ProgressView().progressViewStyle(.circular)
                Text(NSLocalizedString("release", comment: ""))
            }
            .task {
                withAnimation {
                    presentingFinish = false
                    presentingConfirm = true
                }
            }
        } else if (stateResult != nil || medicalResult != nil) {
            VStack {
                Text("Oops, we need a little help")
                List {
                    if let stateResult {
                        Section(NSLocalizedString("Photo ID", comment: "")) {
                            Button(action: {
                                finishModel = stateResult
                            }, label: {
                                HStack {
                                    Image(uiImage: UIImage(cgImage: stateResult.image)).resizable().aspectRatio(1.3, contentMode: .fit)
                                    if stateResult.isComplete {
                                        Text("No issues")
                                    } else {
                                        Text("Needs Direction")
                                    }
                                }
                                .frame(maxHeight: 66)
                            })
                        }
                    }
                    if let medicalResult {
                        Section(NSLocalizedString("Medical ID", comment: "")) {
                            Button(action: {
                                finishModel = medicalResult
                            }, label: {
                                HStack {
                                    Image(uiImage: UIImage(cgImage: medicalResult.image)).resizable().aspectRatio(1.3, contentMode: .fit)
                                    if medicalResult.isComplete {
                                        Text("No issues")
                                    } else {
                                        Text("Needs Direction")
                                    }
                                }
                                .frame(maxHeight: 66)
                            })
                        }
                    }
                }
                ProgressView().progressViewStyle(.circular)
                Text(NSLocalizedString("holding", comment: ""))
            }
            .task {
                withAnimation {
                    presentingCapture = false
                    presentingFinish = true
                }
            }
        } else {
            VStack {
                ProgressView().progressViewStyle(.circular)
                Text(NSLocalizedString("pulling", comment: ""))
            }
            .task {
                withAnimation {
                    presentingCapture = true
                }
            }
        }
    }
    
    @ViewBuilder
    var deviceAppropriateCaptureView: some View {
#if targetEnvironment(simulator)
        EmptyView()
            .task {
                stateResult = .sampleStateID
                medicalResult = .incompleteSample
            }
#else
        DocumentCameraView(completion: { result in
            stateResult = result.stateID
            medicalResult = result.medicalID
        })
#endif
    }
    
    @ViewBuilder
    func completeFormView(with model: Binding<CardScanResultModel?>) -> some View {
        MissingInfoView()
            .presentationDetents([.medium, .large])
    }
    
    @ViewBuilder
    var confirmFormView: some View {
        EmptyView()
            .task {
                completion((stateID: stateResult, medicalID: medicalResult))
            }
    }
}

// Constructed with help from https://augmentedcode.io/2019/07/07/scanning-text-using-swiftui-and-vision-on-ios/
public struct DocumentCameraView: UIViewControllerRepresentable {
    
    private let completion: CardReaderCompletion
    
    init(completion: @escaping CardReaderCompletion) {
        self.completion = completion
    }
    
    public typealias UIViewControllerType = VNDocumentCameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentCameraView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<DocumentCameraView>) {
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: { models in
            let medicalID: CardScanResultModel? = models.reduce(nil) { partialResult, newModel in
                guard newModel.type == .medicalID else {
                    return partialResult
                }
                return partialResult?.join(with: newModel) ?? newModel
            }
            let stateID: CardScanResultModel? = models.reduce(nil) { partialResult, newModel in
                guard newModel.type == .stateID else {
                    return partialResult
                }
                return partialResult?.join(with: newModel) ?? newModel
            }
            completion((stateID: stateID, medicalID: medicalID))
        })
    }
    
    final public class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let completionHandler: ([CardScanResultModel]) -> Void
        
        init(completionHandler: @escaping ([CardScanResultModel]) -> Void) {
            self.completionHandler = completionHandler
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = {
                var images: [UIImage] = []
                for i in 0..<scan.pageCount {
                    images.append(scan.imageOfPage(at: i))
                }
                return images
            }()
            validateImage(images: images, completion: completionHandler)
        }
        
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler([])
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler([])
        }
        
        func validateImage(images: [UIImage], completion: @escaping ([CardScanResultModel]) -> Void) {
            completion(images.compactMap({
                guard let cgImage = $0.cgImage else { return nil }
                let model = CardScanResultModel(image: cgImage)
                return model
            }))
        }
    }
}
