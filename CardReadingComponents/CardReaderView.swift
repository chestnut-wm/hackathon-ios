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

// Constructed with help from https://augmentedcode.io/2019/07/07/scanning-text-using-swiftui-and-vision-on-ios/
public struct CardReaderView: UIViewControllerRepresentable {
    
    private let completionHandler: (CardReaderResult) -> Void
    
    init(completionHandler: @escaping (CardReaderResult) -> Void) {
        self.completionHandler = completionHandler
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
            completionHandler((stateID: stateID, medicalID: medicalID))
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
