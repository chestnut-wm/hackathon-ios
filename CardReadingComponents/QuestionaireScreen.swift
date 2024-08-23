

public enum QuestionaireScreen {
    case expirationDate
    case licenseId
    case careTakerId
    
    var title: String {
        switch self {
        case .expirationDate:
            "Please enter the expiration date:"
        case .licenseId:
            "Please enter your drivers license id:"
        case .careTakerId:
            "Please enter your care taker id:"
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
        }
    }
}
