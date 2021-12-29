//
//  ModelsViewModel.swift
//  furniture
//
//  Created by Nick Patrick on 12/27/21.
//

import Foundation
import FirebaseFirestore

class ModelsViewModel: ObservableObject {
    @Published var models: [Model] = []
    
    private let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("models").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Firestore: No Documents.")
                return
            }
            
            self.models = documents.map { (QueryDocumentSnapshot) -> Model in
                let data = QueryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let categoryText = data["category"] as? String ?? ""
                let category = ModelCategory(rawValue: categoryText) ?? .decor
                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
                
                return Model(name: name, category: category, scaleCompenation: Float(scaleCompensation))
                
            }
        }
    }
}
