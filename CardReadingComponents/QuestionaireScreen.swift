

public enum QuestionaireScreen {
    case expirationDate
    case licenseId
    case careTakerId
    case issueingState
    
    var title: String {
        switch self {
        case .expirationDate:
            "Please enter the expiration date:"
        case .licenseId:
            "Please enter your drivers license id:"
        case .careTakerId:
            "Please enter your care taker id:"
        case .issueingState:
            "Please enter the issueing state:"
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .expirationDate:
            "Expiration date"
        case .licenseId:
            "Drivers license id"
        case .careTakerId:
            "Caretaker id"
        case .issueingState:
            "Issueing state"
        }
    }
}
