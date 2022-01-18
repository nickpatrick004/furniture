//
//  ScenePersistenceHelper.swift
//  furniture
//
//  Created by Nick Patrick on 1/18/22.
//

import Foundation
import RealityKit
import ARKit

class ScenePersisitenceHelper {
    class func saveScene(for arView: CustomARView, at persistenceUrl: URL) {
        print("Save scene to local filesystem.")
        
        // 1. Get current worldMap from arView.session
        arView.session.getCurrentWorldMap { worldMap, error in
            
            // 2. Safely upwrap worldMap
            guard let map = worldMap else {
                print("Persistence Error: unable to get worldMap: \(error!.localizedDescription)")
                return
            }
            
            // 3. Archive data and write to filesystem
            do {
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try sceneData.write(to: persistenceUrl, options: [.atomic])
            } catch {
                print("Persistence Error: Can't save scene to local filesystem: \(error.localizedDescription)")
                
            }
        }
    }
    
    class func loadScene(for arView: CustomARView, with scenePersistenceData: Data) {
        print("Load scene from local filesystem.")
        
        // 1. Unarchive the scenePersistenceData and retrieve ARWorldMap
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData) else { fatalError("Persistence Error: No ARWorldMap in archive.")
                }
                
                return worldMap
            } catch {
                fatalError("Persistence Error: Unable to unarchive ARWorldMap from scenePersistenceData: \(error.localizedDescription)")
            }
        }()
        
        // 2. Reset configuration and load worldMap as initialWorldMap
        let newConfig = arView.defaultConfiguration
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
}
