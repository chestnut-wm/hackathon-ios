//
//  CardScanResultModel.swift
//  CardReadingComponents
//
//  Created by Calvin Chestnut on 8/20/24.
//

import UIKit
import Vision
import VisionKit

class CardScanResultModel: Identifiable {
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
    
    enum IssueingState: CaseIterable {
        static var allCases: [CardScanResultModel.IssueingState] {
            [
                .al,
                .ak,
                .az,
                .ar,
                .as,
                .ca,
                .co,
                .ct,
                .de,
                .dc,
                .fl,
                .ga,
                .gu,
                .hi,
                .id,
                .il,
                .in,
                .ia,
                .ks,
                .ky,
                .la,
                .me,
                .md,
                .ma,
                .mi,
                .mn,
                .ms,
                .mo,
                .mt,
                .ne,
                .nv,
                .nh,
                .nj,
                .nm,
                .ny,
                .nc,
                .nd,
                .mp,
                .oh,
                .ok,
                .or,
                .pa,
                .pr,
                .ri,
                .sc,
                .sd,
                .tn,
                .tx,
                .tt,
                .ut,
                .vt,
                .va,
                .vi,
                .wa,
                .wv,
                .wi,
                .wy
            ]
        }
        
        case al
        case ak
        case az
        case ar
        case `as`
        case ca
        case co
        case ct
        case de
        case dc
        case fl
        case ga
        case gu
        case hi
        case id
        case il
        case `in`
        case ia
        case ks
        case ky
        case la
        case me
        case md
        case ma
        case mi
        case mn
        case ms
        case mo
        case mt
        case ne
        case nv
        case nh
        case nj
        case nm
        case ny
        case nc
        case nd
        case mp
        case oh
        case ok
        case or
        case pa
        case pr
        case ri
        case sc
        case sd
        case tn
        case tx
        case tt
        case ut
        case vt
        case va
        case vi
        case wa
        case wv
        case wi
        case wy
        case un(_ unknownValue: String)
        
        var rawVaule: String {
            
            switch self {
            case .al: return "al"
            case .ak: return "ak"
            case .az: return "az"
            case .ar: return "ar"
            case .as: return "as"
            case .ca: return "ca"
            case .co: return "co"
            case .ct: return "ct"
            case .de: return "de"
            case .dc: return "dc"
            case .fl: return "fl"
            case .ga: return "ga"
            case .gu: return "gu"
            case .hi: return "hi"
            case .id: return "id"
            case .il: return "il"
            case .in: return "in"
            case .ia: return "ia"
            case .ks: return "ks"
            case .ky: return "ky"
            case .la: return "la"
            case .me: return "me"
            case .md: return "md"
            case .ma: return "ma"
            case .mi: return "mi"
            case .mn: return "mn"
            case .ms: return "ms"
            case .mo: return "mo"
            case .mt: return "mt"
            case .ne: return "ne"
            case .nv: return "nv"
            case .nh: return "nh"
            case .nj: return "nj"
            case .nm: return "nm"
            case .ny: return "ny"
            case .nc: return "nc"
            case .nd: return "nd"
            case .mp: return "mp"
            case .oh: return "oh"
            case .ok: return "ok"
            case .or: return "or"
            case .pa: return "pa"
            case .pr: return "pr"
            case .ri: return "ri"
            case .sc: return "sc"
            case .sd: return "sd"
            case .tn: return "tn"
            case .tx: return "tx"
            case .tt: return "tt"
            case .ut: return "ut"
            case .vt: return "vt"
            case .va: return "va"
            case .vi: return "vi"
            case .wa: return "wa"
            case .wv: return "wv"
            case .wi: return "wi"
            case .wy: return "wy"
            case .un(let value): return value
            }
        }
        
        init(abbreviatedValue: String) {
            switch abbreviatedValue {
            case "al": self = .al
            case "ak": self = .ak
            case "az": self = .az
            case "ar": self = .ar
            case "as": self = .as
            case "ca": self = .ca
            case "co": self = .co
            case "ct": self = .ct
            case "de": self = .de
            case "dc": self = .dc
            case "fl": self = .fl
            case "ga": self = .ga
            case "gu": self = .gu
            case "hi": self = .hi
            case "id": self = .id
            case "il": self = .il
            case "in": self = .in
            case "ia": self = .ia
            case "ks": self = .ks
            case "ky": self = .ky
            case "la": self = .la
            case "me": self = .me
            case "md": self = .md
            case "ma": self = .ma
            case "mi": self = .mi
            case "mn": self = .mn
            case "ms": self = .ms
            case "mo": self = .mo
            case "mt": self = .mt
            case "ne": self = .ne
            case "nv": self = .nv
            case "nh": self = .nh
            case "nj": self = .nj
            case "nm": self = .nm
            case "ny": self = .ny
            case "nc": self = .nc
            case "nd": self = .nd
            case "mp": self = .mp
            case "oh": self = .oh
            case "ok": self = .ok
            case "or": self = .or
            case "pa": self = .pa
            case "pr": self = .pr
            case "ri": self = .ri
            case "sc": self = .sc
            case "sd": self = .sd
            case "tn": self = .tn
            case "tx": self = .tx
            case "tt": self = .tt
            case "ut": self = .ut
            case "vt": self = .vt
            case "va": self = .va
            case "vi": self = .vi
            case "wa": self = .wa
            case "wv": self = .wv
            case "wi": self = .wi
            case "wy": self = .wy
            default:
                self = .un(abbreviatedValue)
            }
        }
        
        init(rawValue: String) {
            let value = rawValue.lowercased().filter({ !$0.isWhitespace })
            if rawValue.count == 2 {
                self.init(abbreviatedValue: rawValue)
            }
            var potentialMatches: [Self] = []
            for state in IssueingState.allCases {
                if !value.ranges(of: state.displayString.lowercased().filter({ !$0.isWhitespace })).isEmpty {
                    potentialMatches.append(state)
                }
            }
            switch value {
            case Self.al.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .al
            case Self.ak.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ak
            case Self.az.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .az
            case Self.ar.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ar
            case Self.as.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .as
            case Self.ca.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ca
            case Self.co.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .co
            case Self.ct.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ct
            case Self.de.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .de
            case Self.dc.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .dc
            case Self.fl.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .fl
            case Self.ga.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ga
            case Self.gu.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .gu
            case Self.hi.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .hi
            case Self.id.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .id
            case Self.il.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .il
            case Self.in.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .in
            case Self.ia.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ia
            case Self.ks.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ks
            case Self.ky.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ky
            case Self.la.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .la
            case Self.me.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .me
            case Self.md.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .md
            case Self.ma.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ma
            case Self.mi.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .mi
            case Self.mo.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .mo
            case Self.mt.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .mt
            case Self.ne.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ne
            case Self.nv.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nv
            case Self.nh.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nh
            case Self.nj.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nj
            case Self.nm.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nm
            case Self.ny.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ny
            case Self.nc.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nc
            case Self.nd.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .nd
            case Self.mp.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .mp
            case Self.oh.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .oh
            case Self.ok.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ok
            case Self.or.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .or
            case Self.pa.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .pa
            case Self.pr.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .pr
            case Self.ri.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ri
            case Self.sc.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .sc
            case Self.sd.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .sd
            case Self.tn.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .tn
            case Self.tx.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .tx
            case Self.tt.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .tt
            case Self.ut.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .ut
            case Self.vt.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .vt
            case Self.va.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .va
            case Self.vi.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .vi
            case Self.wa.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .wa
            case Self.wi.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .wi
            case Self.wv.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .wv
            case Self.wy.displayString.filter({ !$0.isWhitespace }).lowercased(): self = .wy
            default:
                if let firstPotential = potentialMatches.first {
                    self = firstPotential
                } else {
                    self.init(abbreviatedValue: value)
                }
            }
        }
        
        var displayString: String {
            switch self {
            case .al:
                return NSLocalizedString("Alabama", comment: "")
            case .ak:
                return NSLocalizedString("Alaska", comment: "")
            case .az:
                return NSLocalizedString("Arizona", comment: "")
            case .ar:
                return NSLocalizedString("Arkansas", comment: "")
            case .as:
                return NSLocalizedString("American Samoa", comment: "")
            case .ca:
                return NSLocalizedString("California", comment: "")
            case .co:
                return NSLocalizedString("Colorado", comment: "")
            case .ct:
                return NSLocalizedString("Connecticut", comment: "")
            case .de:
                return NSLocalizedString("Delaware", comment: "")
            case .dc:
                return NSLocalizedString("District of Columbia", comment: "")
            case .fl:
                return NSLocalizedString("Florida", comment: "")
            case .ga:
                return NSLocalizedString("Georgia", comment: "")
            case .gu:
                return NSLocalizedString("Guam", comment: "")
            case .hi:
                return NSLocalizedString("Hawaii", comment: "")
            case .id:
                return NSLocalizedString("Idaho", comment: "")
            case .il:
                return NSLocalizedString("Illinois", comment: "")
            case .in:
                return NSLocalizedString("Indiana", comment: "")
            case .ia:
                return NSLocalizedString("Iowa", comment: "")
            case .ks:
                return NSLocalizedString("Kansas", comment: "")
            case .ky:
                return NSLocalizedString("Kentucky", comment: "")
            case .la:
                return NSLocalizedString("Louisiana", comment: "")
            case .me:
                return NSLocalizedString("Maine", comment: "")
            case .md:
                return NSLocalizedString("Maryland", comment: "")
            case .ma:
                return NSLocalizedString("Massachusetts", comment: "")
            case .mi:
                return NSLocalizedString("Michigan", comment: "")
            case .mn:
                return NSLocalizedString("Minnesota", comment: "")
            case .ms:
                return NSLocalizedString("Mississippi", comment: "")
            case .mo:
                return NSLocalizedString("Missouri", comment: "")
            case .mt:
                return NSLocalizedString("Montana", comment: "")
            case .ne:
                return NSLocalizedString("Nebraska", comment: "")
            case .nv:
                return NSLocalizedString("Nevada", comment: "")
            case .nh:
                return NSLocalizedString("New Hampshire", comment: "")
            case .nj:
                return NSLocalizedString("New Jersey", comment: "")
            case .nm:
                return NSLocalizedString("New Mexico", comment: "")
            case .ny:
                return NSLocalizedString("New York", comment: "")
            case .nc:
                return NSLocalizedString("North Carolina", comment: "")
            case .nd:
                return NSLocalizedString("North Dakota", comment: "")
            case .mp:
                return NSLocalizedString("Northern Mariana Islands", comment: "")
            case .oh:
                return NSLocalizedString("Ohio", comment: "")
            case .ok:
                return NSLocalizedString("Oklahoma", comment: "")
            case .or:
                return NSLocalizedString("Oregon", comment: "")
            case .pa:
                return NSLocalizedString("Pennsylvania", comment: "")
            case .pr:
                return NSLocalizedString("Puerto Rico", comment: "")
            case .ri:
                return NSLocalizedString("Rhode Island", comment: "")
            case .sc:
                return NSLocalizedString("South Carolina", comment: "")
            case .sd:
                return NSLocalizedString("South Dakota", comment: "")
            case .tn:
                return NSLocalizedString("Tennessee", comment: "")
            case .tx:
                return NSLocalizedString("Texas", comment: "")
            case .tt:
                return NSLocalizedString("Trust Territories", comment: "")
            case .ut:
                return NSLocalizedString("Utah", comment: "")
            case .vt:
                return NSLocalizedString("Vermont", comment: "")
            case .va:
                return NSLocalizedString("Virginia", comment: "")
            case .vi:
                return NSLocalizedString("Virgin Islands", comment: "")
            case .wa:
                return NSLocalizedString("Washington", comment: "")
            case .wv:
                return NSLocalizedString("West Virginia", comment: "")
            case .wi:
                return NSLocalizedString("Wisconsin", comment: "")
            case .wy:
                return NSLocalizedString("Wyoming", comment: "")
            case .un(_):
                return NSLocalizedString("", comment: "")
            }
        }
        
        static var knownMedicalText: [String] {
            return [
                "Patient",
                "Cannabis",
                "Control",
                "Commission",
                "Commonwealth of Massachusetts",
                "Medical Program",
                "Registration",
                "Number",
                "ID Card Expiration Date",
                "Medical",
                "Marijuana"
            ]
        }
        static var knownLicenseText: [String] {
            ["Driver's", "Liscense", "State", "ID"]
        }
    }
    
    enum CardType: String, CaseIterable, Identifiable {
        case stateID = "State ID"
        case medicalID = "Medical ID"
        
        static var relevantWords: [String] {
            return CardScanResultModel.IssueingState.allCases.reduce([], { partialResult, state in
                return Array(Set(partialResult + [state.rawVaule] + IssueingState.knownMedicalText + IssueingState.knownLicenseText))
            })
        }
        
        var id: String { self.rawValue }
    }
    
    // The temporal string tracker.
//    let stringTracker = StringTracker()
    
    let id = UUID()
    let image: CGImage
    var type: CardType?
    var licenseNumber: String?
    var expirationDate: String?
    var issueingState: IssueingState?
    var caregiverIDNumber: String?
    var name: String?
    
    init(image: CGImage, type: CardType? = nil, cardNumber: String? = nil, expirationDate: String? = nil, issueingState: IssueingState? = nil, caregiverIDNumber: String? = nil, name: String? = nil) {
        self.image = image
        self.type = type
        self.licenseNumber = cardNumber
        self.expirationDate = expirationDate
        self.issueingState = issueingState
        self.caregiverIDNumber = caregiverIDNumber
        self.name = name
        
        if !isComplete {
            let handler = VNImageRequestHandler(cgImage: image)
            let request = VNRecognizeTextRequest(completionHandler: self.evaluate(request:error:))
            request.recognitionLevel = .accurate
            request.automaticallyDetectsLanguage = false
            request.customWords = CardType.relevantWords
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
            return issueingState != nil &&
            !(licenseNumber ?? caregiverIDNumber ?? "").isEmpty &&
            !(expirationDate ?? "").isEmpty
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
        
        if recognizedText.contains(where: { IssueingState.knownMedicalText.contains($0) }) {
            type = .medicalID
        } else {
            type = .stateID
        }
        let state = recognizedText.compactMap({ IssueingState(rawValue: $0) }).filter({ state in
            switch state {
            case .un:
                return false
            default:
                return true
            }
        }).first ?? IssueingState(rawValue: recognizedText.first ?? "")
        
        switch type {
        case .medicalID:
            setupMedicalFields(for: state, with: recognizedText)
        default:
            self.issueingState = state
        }
    }
    
    func setupMedicalFields(for state: IssueingState, with results: [String]) {
        var filteredFields = results.filter({ result in
            !IssueingState.knownMedicalText.map({ $0.lowercased() }).contains(result.lowercased())
        })
        var workingFields = filteredFields
        issueingState = state
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
            if let firstDate = workingFields.firstIndex(where: { Self.standardDateFormatter.date(from: $0) != nil }) {
                expirationDate = workingFields[firstDate]
                workingFields.remove(at: firstDate)
            }
            if let idIndex = workingFields.firstIndex(where: { string in
                string.firstMatch(of: /^[A-Za-z]\d+$/) != nil
            }) {
                let id = workingFields[idIndex]
                if id.hasPrefix("C") {
                    // Is caregiver card
                    caregiverIDNumber = id
                } else {
                    licenseNumber = id
                }
                workingFields.remove(at: idIndex)
            }
            if let nextIdIndex = workingFields.firstIndex(where: { string in
                string.firstMatch(of: /^[A-Za-z]\d+$/) != nil
            }) {
                let id = workingFields[nextIdIndex]
                // If we already have a caregiver ID BUT we found another ID candidate, override?
                if let previousID = caregiverIDNumber {
                    licenseNumber = previousID
                }
                caregiverIDNumber = id
            }
            if expirationDate == nil && !workingFields.isEmpty, let dateIndex = pickBestDate(from: workingFields) {
                expirationDate = workingFields[dateIndex]
                workingFields.remove(at: dateIndex)
            }
            if licenseNumber == nil && !workingFields.isEmpty, let idIndex = pickBestID(from: workingFields) {
                licenseNumber = workingFields[idIndex]
                workingFields.remove(at: idIndex)
            }
            
        default:
            print("Check")
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
//        let potentialNameIDs: [Int] = filteredFields.compactMap({ $0. })
    }
    
    func pickBestDate(from options: [String]) -> Int? {
        if let index = options.firstIndex(where: { Self.standardDateFormatter.date(from: $0) != nil }) {
            return index
        } else {
            return options.firstIndex(where: { Self.genericFormatter.date(from: $0) != nil })
        }
    }
    
    func pickBestID(from options: [String]) -> Int? {
        options.firstIndex(where: { $0.firstMatch(of: /^[A-Za-z]{1,3}\d+$/) != nil })
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
