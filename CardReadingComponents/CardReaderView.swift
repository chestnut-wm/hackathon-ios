//
//  Copyright © 2024 Weedmaps LLC. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit

@available(iOS 17.0, *)
typealias CardReaderResult = (stateID: CardScanResultModel?, medicalID: CardScanResultModel?)
@available(iOS 17.0, *)
typealias CardReaderCompletion = ((CardReaderResult) -> Void)

// Constructed with help from https://augmentedcode.io/2019/07/07/scanning-text-using-swiftui-and-vision-on-ios/
@available(iOS 17.0, *)
public struct CardReaderView: UIViewControllerRepresentable {
    
    private let completion: CardReaderCompletion
    
    init(completion: @escaping CardReaderCompletion) {
        self.completion = completion
    }
    
    public typealias UIViewControllerType = VNDocumentCameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CardReaderView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<CardReaderView>) {
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
    
    public final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let completionHandler: ([CardScanResultModel]) -> Void
        
        init(completionHandler: @escaping ([CardScanResultModel]) -> Void) {
            self.completionHandler = completionHandler
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = (0..<scan.pageCount).map({ scan.imageOfPage(at: $0) })
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
                guard let cgImage = $0.cgImage else {
                    return nil
                }
                let model = CardScanResultModel(image: cgImage)
                return model
            }))
        }
    }
}
