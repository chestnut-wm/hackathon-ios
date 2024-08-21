//
//  CardReaderView.swift
//  CardReadingComponents
//
//  Created by Calvin Chestnut on 8/20/24.
//

import SwiftUI
import Vision
import VisionKit


// Constructed with help from https://augmentedcode.io/2019/07/07/scanning-text-using-swiftui-and-vision-on-ios/
public struct CardReaderView: UIViewControllerRepresentable {
    
    let cardType: CardScanResultModel.CardType
    private let completionHandler: (CardScanResultModel?) -> Void
    
    init(_ type: CardScanResultModel.CardType = .medicalID, completionHandler: @escaping (CardScanResultModel?) -> Void) {
        self.cardType = type
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
        Coordinator(cardType, completionHandler: completionHandler)
    }
    
    final public class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        let cardType: CardScanResultModel.CardType
        private let completionHandler: (CardScanResultModel?) -> Void
        
        init(_ type: CardScanResultModel.CardType = .medicalID, completionHandler: @escaping (CardScanResultModel?) -> Void) {
            self.cardType = type
            self.completionHandler = completionHandler
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            let image = scan.imageOfPage(at: 0)
            validateImage(image: image, completion: completionHandler)
        }
        
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
        
        func validateImage(image: UIImage?, completion: @escaping (CardScanResultModel?) -> Void) {
            guard let cgImage = image?.cgImage else { return completion(nil) }
            
            let model = CardScanResultModel(image: cgImage, type: cardType)
            
            completion(model)
        }
    }
}
