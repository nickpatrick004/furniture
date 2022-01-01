//
//  AppDelegate.swift
//  furniture
//
//  Created by Nick Patrick on 12/16/21.
//


import SwiftUI
import Firebase

@main
struct furniture: App {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    @StateObject var sceneManager = SceneManager()
    
    init() {
        FirebaseApp.configure()
        
        // Anonymous authentication with Firebase
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("FAILED: Anonymous Authentication with Firebase.")
                return
            }
            
            let uid = user.uid
            print("Firebase: Anonymous user authentication with uid: \(uid).")
            
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
                .environmentObject(sceneManager)
            
        }
    }
}
   
