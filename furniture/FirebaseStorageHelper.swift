//
//  FirebaseStorageHelper.swift
//  furniture
//
//  Created by Nick Patrick on 12/28/21.
//

import Foundation
import Firebase

class FirebaseStorageHelper {
    static private let cloudStorage = Storage.storage()
    
    class func asyncDownloadToFilesystem(relativePath: String, handler: @escaping (_ fileUrl: URL) -> Void) {
        // Create local filesystem URL
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        // Check if asset is already in the local filesystem
        // if it is, load that asset an return
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            handler(fileUrl)
            return
        }
        
        // Create a regerance to the asset
        let storageRef = cloudStorage.reference(withPath: relativePath)
        
        // Download to the local filesystem
        storageRef.write(toFile: fileUrl) { url, error in
            guard let localUrl = url else {
                print("firebase storage: Error downloading file with relativePath: \(relativePath)")
                return
            }
            
            handler(localUrl)
        }.resume()
    }
}
