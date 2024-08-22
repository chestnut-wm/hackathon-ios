//
//  MissingInfoView.swift
//  CardReadingComponents
//
//  Created by Enrique Florencio on 8/21/24.
//

import SwiftUI

struct MissingInfoView: View {
    
    @State private var expirationDate: String = ""
    @State private var issueingState: String = ""
    @State private var licenseID: String = ""
    @State private var dateOfBirth: String = ""
    @State private var selectedIDType: CardScanResultModel.CardType = .stateID
    @State private var selectedDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Please fill in the missing information:")
                .font(.headline)
                .padding(.bottom, 20)

            Group {
                Text("Card Type:")
                Picker("Select Card Type", selection: $selectedIDType) {
                    ForEach(CardScanResultModel.CardType.allCases) { idType in
                        Text(idType.rawValue).tag(idType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 10)

                Text("Driver's License ID:")
                TextField("Enter your license ID", text: $licenseID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Issueing State:")
                TextField("Enter the issueing state", text: $issueingState)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Expiration Date:")
                TextField("Enter the expiration date", text: $expirationDate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                DatePicker(
                    "Enter your birthday:",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
            }

            Spacer()
            
            Button(action: {
                print("License ID: \(licenseID)")
                print("Date of Birth: \(dateOfBirth)")
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Missing Information")
    }
}

struct MissingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MissingInfoView()
    }
}
