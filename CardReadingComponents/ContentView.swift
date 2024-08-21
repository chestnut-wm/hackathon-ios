//
//  ContentView.swift
//  CardReadingComponents
//
//  Created by Calvin Chestnut on 8/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State
    var items: [CardScanResultModel] = []
    
    @State
    var showSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        Text("Destination")
                    } label: {
                        HStack {
                            Image(uiImage: UIImage(cgImage: item.image))
                            VStack {
                                if let number = item.licenseNumber {
                                    Text(number)
                                }
                                if let name = item.name {
                                    Text(name)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
//        .onReceive($receiedModel, perform: { output in
//            items.append(output)
//            
//        })
        .sheet(isPresented: $showSheet) {
            CardReaderView { model in
                guard let model else {
                    return
                }
                items.append(model)
                if model.isComplete {
                    withAnimation {
                        showSheet = false
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            showSheet = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            items.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ContentView()
}
