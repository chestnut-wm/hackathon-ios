//
//  Copyright © 2024 Weedmaps LLC. All rights reserved.
//

import UIKit
import Vision
import VisionKit

@available(iOS 17.0, *)
class CardScanResultModel: Identifiable {
    static var incompleteSample: CardScanResultModel {
        .init(
            image: UIImage(named: "sample")!.cgImage!,
            type: .medicalID,
            cardNumber: "p12345",
            expirationDate: nil,
            issueingState: nil,
            caregiverIDNumber: "c1234",
            name: "Some Name"
        )
    }
    static var completeSample: CardScanResultModel {
        .init(
            image: UIImage(named: "sample")!.cgImage!,
            type: .medicalID,
            cardNumber: "p12345",
            expirationDate: "11/18/2025",
            issueingState: .ma,
            caregiverIDNumber: "c1234",
            name: "Some Name"
        )
    }
    static var sampleStateID: CardScanResultModel {
        .init(
            image: UIImage(named: "sample")!.cgImage!,
            type: .stateID,
            expirationDate: "11/18/2025",
            issueingState: .ma,
            name: "Some Name"
        )
    }
    static let nameFormatter: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        
        if let preferredLanguage = Locale.preferredLanguages.first {
            formatter.locale = .init(languageCode: .init(stringLiteral: preferredLanguage))
        } else {
            formatter.locale = .autoupdatingCurrent
        }
        formatter.style = .long
        
        return formatter
    }()
    static var standardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    static var genericFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en/US")
        return formatter
    }()
    
    static var relevantWords: [String] {
        Array(
            Set(
                CardIssuingMunicipality.allCases.reduce([], { partialResult, state in
                    partialResult + [state.rawVaule]
                })
                + Self.knownMedicalText
                + Self.knownLicenseText
            )
        )
    }
    static var knownMedicalText: [String] {
        [
            "Patient", "Cannabis", "Control", "Commission", "Commonwealth of Massachusetts", "Medical Program", "Registration", "Number", "ID Card Expiration Date", "Medical", "Marijuana"
        ]
    }
    static var knownLicenseText: [String] {
        ["Driver's", "Liscense", "State", "ID"]
    }
    enum CardType: String, CaseIterable, Identifiable {
        case stateID = "Photo ID"
        case medicalID = "Medical ID"
            
        var id: String { self.rawValue }
        var displayName: String { self.rawValue }
    }
    
    let id = UUID()
    let image: CGImage
    var type: CardType?
    var licenseNumber: String?
    var expirationDate: String?
    var issueingState: CardIssuingMunicipality?
    var caregiverIDNumber: String?
    var name: String?
    
    var workingFields: [String] = []
    
    init(image: CGImage, type: CardType? = nil, cardNumber: String? = nil, expirationDate: String? = nil, issueingState: CardIssuingMunicipality? = nil, caregiverIDNumber: String? = nil, name: String? = nil) {
        self.image = image
        self.type = type
        self.licenseNumber = cardNumber
        self.expirationDate = expirationDate
        self.issueingState = issueingState
        self.caregiverIDNumber = caregiverIDNumber
        self.name = name
        
        if !isComplete && type == nil {
            let handler = VNImageRequestHandler(cgImage: image)
            let request = VNRecognizeTextRequest(completionHandler: self.evaluate(request:error:))
            request.recognitionLevel = .accurate
            request.automaticallyDetectsLanguage = false
            request.customWords = Self.relevantWords
            do {
                try handler.perform(
                    [
                        VNRecognizeTextRequest(
                            completionHandler: self.evaluate(request:error:)
                        )
                    ]
                )
            } catch {
                print("Handle error")
            }
        }
    }
    
    var isComplete: Bool {
        guard let type else {
            return false
        }
        switch type {
        case .medicalID:
            return !(issueingState == nil || (licenseNumber ?? caregiverIDNumber ?? "").isEmpty || (expirationDate ?? "").isEmpty)
        case .stateID:
            return issueingState != nil
        }
    }
    
    func evaluate(request: VNRequest, error: Error?) {
        guard let results = request.results,
              !results.isEmpty,
              let requestResults = request.results as? [VNRecognizedTextObservation]
        else { return }
        let recognizedText = requestResults.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        if recognizedText.contains(where: { Self.knownMedicalText.contains($0) }) {
            type = .medicalID
        } else {
            type = .stateID
        }
        let state = recognizedText.compactMap({ CardIssuingMunicipality(rawValue: $0) }).filter({ state in
            switch state {
            case .un:
                return false
            default:
                return true
            }
        }).first ?? CardIssuingMunicipality(rawValue: recognizedText.first ?? "")
        
        switch type {
        case .medicalID:
            setupMedicalFields(for: state, with: recognizedText)
        default:
            self.issueingState = state
        }
    }
    
    // swiftlint:disable:next function_body_length
    func setupMedicalFields(for state: CardIssuingMunicipality, with results: [String]) {
        var filteredFields = results.filter({ result in
            !Self.knownMedicalText.map({ $0.lowercased() }).contains(result.lowercased())
        })
        workingFields = filteredFields
        issueingState = state
        
        if let firstDate = workingFields.firstIndex(where: { Self.standardDateFormatter.date(from: $0) != nil }) {
            expirationDate = workingFields[firstDate]
            workingFields.remove(at: firstDate)
        }
        
        switch state {
        case .ma:
            if let index = results.firstIndex(where: { $0.lowercased().contains("medical program") }), results.endIndex >= index + 2 {
                let maybeLastName = results[index + 1]
                let maybeFirstName = results[index + 2]
                
                let maybeName = [maybeFirstName, maybeLastName].joined(separator: " ")
                workingFields.removeAll(where: { $0 == maybeFirstName || $0 == maybeLastName })
                if let components = Self.nameFormatter.personNameComponents(from: maybeName) {
                    self.name = Self.nameFormatter.string(from: components)
                } else {
                    self.name = maybeName
                }
            }
            if let idIndex = pickBestID(with: "^[A-Za-z]\\d+$", from: workingFields) {
                let id = workingFields[idIndex]
                if id.hasPrefix("C") {
                    // Is caregiver card
                    caregiverIDNumber = id
                } else {
                    licenseNumber = id
                }
                workingFields.remove(at: idIndex)
            }
            if let nextIdIndex = pickBestID(with: "^[A-Za-z]\\d+$", from: workingFields) {
                let id = workingFields[nextIdIndex]
                // If we already have a caregiver ID BUT we found another ID candidate, override?
                if let previousID = caregiverIDNumber {
                    licenseNumber = previousID
                }
                caregiverIDNumber = id
            }
            
        default:
            if let idIndex = pickBestID(with: "^[A-Za-z]\\d+$", from: workingFields) {
                let id = workingFields[idIndex]
                if id.hasPrefix("C") {
                    // Is caregiver card
                    caregiverIDNumber = id
                } else {
                    licenseNumber = id
                }
                workingFields.remove(at: idIndex)
            }
            if let nextIdIndex = pickBestID(with: "^[A-Za-z]\\d+$", from: workingFields) {
                let id = workingFields[nextIdIndex]
                // If we already have a caregiver ID BUT we found another ID candidate, override?
                if let previousID = caregiverIDNumber {
                    licenseNumber = previousID
                }
                caregiverIDNumber = id
            }
            if licenseNumber == nil && !workingFields.isEmpty, let idIndex = pickBestID(from: workingFields) {
                licenseNumber = workingFields[idIndex]
                workingFields.remove(at: idIndex)
            }
        }
        if expirationDate == nil && !workingFields.isEmpty, let dateIndex = pickBestDate(from: workingFields) {
            expirationDate = workingFields[dateIndex]
            workingFields.remove(at: dateIndex)
        }
        if licenseNumber == nil && !workingFields.isEmpty, let idIndex = pickBestID(from: workingFields) {
            licenseNumber = workingFields[idIndex]
            workingFields.remove(at: idIndex)
        }
        if expirationDate == nil && !filteredFields.isEmpty, let dateIndex = pickBestDate(from: filteredFields) {
            expirationDate = filteredFields[dateIndex]
            filteredFields.remove(at: dateIndex)
        }
        if licenseNumber == nil && !filteredFields.isEmpty, let idIndex = pickBestID(from: filteredFields) {
            licenseNumber = filteredFields[idIndex]
            filteredFields.remove(at: idIndex)
        }
        if expirationDate == nil, let dateIndex = pickBestDate(from: results) {
            expirationDate = results[dateIndex]
        }
        if licenseNumber == nil, let idIndex = pickBestID(from: results) {
            licenseNumber = results[idIndex]
        }
    }
    
    func pickBestDate(from options: [String]) -> Int? {
        if let index = options.firstIndex(where: { Self.standardDateFormatter.date(from: $0) != nil }) {
            return index
        } else {
            return options.firstIndex(where: { Self.genericFormatter.date(from: $0) != nil })
        }
    }
    
    func pickBestID(with pattern: String = "^[A-Za-z]{1,3}\\d+$", from options: [String]) -> Int? {
        options.firstIndex(where: { option in
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []), let range = NSRange(option) else {
                return false
            }
            return regex.numberOfMatches(in: option, options: [], range: range) != 0
        })
    }
    
    func join(with other: CardScanResultModel) -> CardScanResultModel {
        guard other.type == type, type == .medicalID else {
            return self
        }
        if other.isComplete && !isComplete {
            return other
        }
        var otherPreferred = 0
        var preferredNumber = licenseNumber
        if let otherCard = other.licenseNumber, (preferredNumber ?? "").isEmpty {
            preferredNumber = otherCard
            otherPreferred += 1
        }
        var preferredCaregiver = caregiverIDNumber
        if let otherCaregiver = other.caregiverIDNumber, (preferredCaregiver ?? "").isEmpty {
            preferredCaregiver = otherCaregiver
            otherPreferred += 1
        }
        var preferredExpiration = expirationDate
        if let otherDate = other.expirationDate, (preferredExpiration ?? "").isEmpty {
            preferredExpiration = otherDate
            otherPreferred += 1
        }
        var preferredState = issueingState
        if let otherDate = other.issueingState, preferredState == nil {
            preferredState = otherDate
            otherPreferred += 1
        }
        var preferredName = name
        if let otherName = other.name, (preferredName ?? "").isEmpty {
            preferredName = otherName
            otherPreferred += 1
        }
        
        return CardScanResultModel(
            image: otherPreferred > 2 ? other.image : image,
            type: self.type,
            cardNumber: preferredNumber,
            expirationDate: preferredExpiration,
            issueingState: preferredState,
            caregiverIDNumber: preferredCaregiver,
            name: preferredName
        )
    }
}
