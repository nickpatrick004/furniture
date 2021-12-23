//
//  AppDelegate.swift
//  furniture
//
//  Created by Nick Patrick on 12/16/21.
//


import SwiftUI

@main
struct furniture: App {
    @StateObject var placementSettings = PlacementSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}
   
