//
//  Copyright © 2024 Weedmaps LLC. All rights reserved.
//

import SwiftUI
import Foundation

final class MissingInfoViewModel: ObservableObject {
    
    @Published public var expirationDate: Date
    @Published public var issueingState: String
    @Published public var licenseID: String
    @Published public var dateOfBirth: Date
    @Published public var selectedIDType: CardScanResultModel.CardType
    @Published public var selectedDate: Date
    @Published public var careTakerID: String
    @Published public var currentStepIndex: Int = 0
    
    init(expirationDate: Date, issueingState: String, licenseID: String, dateOfBirth: Date, selectedIDType: CardScanResultModel.CardType, selectedDate: Date, careTakerId: String) {
        self.expirationDate = expirationDate
        self.issueingState = issueingState
        self.licenseID = licenseID
        self.dateOfBirth = dateOfBirth
        self.selectedIDType = selectedIDType
        self.selectedDate = selectedDate
        self.careTakerID = careTakerId
    }
    
    public var steps: [QuestionaireScreen] = [.licenseId, .careTakerId, .expirationDate]
    
    public var currentStep: QuestionaireScreen {
        steps[currentStepIndex]
    }
    
    func goToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        } else {
            submit()
        }
    }
    
    func submit() { }
    
    func enter<T>(value: T) {
        switch currentStep {
        case .idType:
            if let value = value as? CardScanResultModel.CardType {
                self.selectedIDType = value
            }
        case .expirationDate:
            if let value = value as? Date {
                self.expirationDate = value
            }
        case .licenseId:
            if let value = value as? String {
                self.licenseID = value
            }
        case .careTakerId:
            if let value = value as? String {
                self.careTakerID = value
            }
        }
    }
}

@available(iOS 17.0, *)
struct MissingInfoView: View {
    
    @Binding
    var model: CardScanResultModel?
  
    @StateObject private var viewModel: MissingInfoViewModel
    @State private var showNextStep: Bool = false
    
    @State private var stringValue: String = ""
    @State private var cardValue: CardScanResultModel.CardType? = nil
    @State private var dateValue: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(viewModel: MissingInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            MissingInfoDetailsView(viewModel: viewModel)
        }
    }
}

struct MissingInfoDetailsView: View {
    
    @ObservedObject private var viewModel: MissingInfoViewModel
    @State private var showNextStep: Bool = false
    
    @State private var stringValue: String = ""
    @State private var cardValue: CardScanResultModel.CardType? = nil
    @State private var dateValue: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(viewModel: MissingInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.currentStep.title)
                .font(.headline)
                .padding(.bottom, 20)
            
            content()
            
            Spacer()
            
            Button(action: {
                if !stringValue.isEmpty {
                    viewModel.enter(value: stringValue)
                } else if let cardValue {
                    viewModel.enter(value: cardValue)
                } else if dateValue != Date() {
                    viewModel.enter(value: dateValue)
                }
                
                viewModel.goToNextStep()
                showNextStep = true
            }) {
                Text(viewModel.currentStepIndex < viewModel.steps.count - 1 ? "Next" : "Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            NavigationLink(
                destination: MissingInfoView(viewModel: viewModel),
                isActive: $showNextStep,
                label: { EmptyView() }
            )
        }
        .padding()
    }
    
    @ViewBuilder
    private func content() -> some View {
        switch viewModel.currentStep {
        case .idType:
            Picker(viewModel.currentStep.placeHolderText, selection: $cardValue) {
                ForEach(CardScanResultModel.CardType.allCases) { idType in
                    Text(idType.rawValue).tag(idType)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 10)
        case .expirationDate:
            DatePicker(
                viewModel.currentStep.placeHolderText,
                selection: $dateValue,
                displayedComponents: [.date]
            )
            .padding(.bottom, 10)
        default:
            TextField(viewModel.currentStep.placeHolderText, text: $stringValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        }
}

@available(iOS 17.0, *)
struct MissingInfoView_Previews: PreviewProvider {
    @State
    static var model: CardScanResultModel? = CardScanResultModel.incompleteSample
    
    static var previews: some View {
        MissingInfoView(model: $model)
    }
}
