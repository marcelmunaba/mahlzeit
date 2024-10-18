//
//  MahlzeitApp.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 08.10.24.
//

import SwiftUI

@main
struct MahlzeitApp: App {
    var mockModel = MockModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(mockModel, id: mockModel.dishes.first?.id).tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .environment(mockModel)
                
                HistoryView(model: mockModel).tabItem {
                    Image(systemName: "checkmark.arrow.trianglehead.counterclockwise")
                    Text("History")
                }
                .environment(mockModel)
            }
        }
    }
}
