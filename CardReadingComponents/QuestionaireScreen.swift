

public enum QuestionaireScreen {
    case idType
    case expirationDate
    case licenseId
    case careTakerId
    
    var title: String {
        switch self {
        case .idType:
            "Please select the card type:"
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
        case .idType:
            "Card type"
        case .expirationDate:
            "Expiration date"
        case .licenseId:
            "Drivers license id"
        case .careTakerId:
            "Caretaker id"
        }
    }
}
