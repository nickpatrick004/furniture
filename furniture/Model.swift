//
//  Model.swift
//  furniture
//
//  Created by Nick Patrick on 12/18/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable {
    case table
    case chair
    case decor
    case light
    
    var label: String {
        get {
            switch self {
            case .table:
                return "Tables"
            case .chair:
                return "Chairs"
            case .decor:
                return "Decor"
            case .light:
                return "Lights"
            }
        }
    }
}

class Model: ObservableObject, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var category: ModelCategory
    @Published var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompenation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompenation
        
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(self.name).png") { localUrl in
            do {
                let imageData = try Data(contentsOf: localUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    func asyncLoadModelEntity() {
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(self.name).usdz") { localUrl in
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl)
                .sink(receiveCompletion: { loadCompletion in
                
                    switch loadCompletion {
                    case .failure(let error) : print("Unable to load modelEntity for \(self.name). Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                    
                }, receiveValue: { modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale += self.scaleCompensation
                    
                    print("modelEntity for \(self.name) has been loaded.")
                
                })
        }
    }
}

//struct Models {
//    var all: [Model] = []
//    
//    init() {
//        // Tables
//        let diningTable = Model(name: "dining_table", category: .table, scaleCompenation: 0.32/100)
//        let Santa_Claus = Model(name: "Santa_Claus", category: .table, scaleCompenation: 0.32/100)
//        
//        self.all += [diningTable, Santa_Claus]
//        
//        
//        // Chairs
//        let diningChair = Model(name: "dining_chair", category: .chair, scaleCompenation: 0.32/100)
//        let eamesChairWhite = Model(name: "eames_chair_white", category: .chair, scaleCompenation: 0.32/100)
//        let eamesChairWoodgrain = Model(name: "eames_chair_woodgrain", category: .chair, scaleCompenation: 0.32/100)
//        let eamesChairBlackLeather = Model(name: "eames_chair_black_leather", category: .chair, scaleCompenation: 0.32/100)
//        let eamesChairBrownLeather = Model(name: "eames_chair_brown_leather", category: .chair, scaleCompenation: 0.32/100)
//        
//        self.all += [diningChair, eamesChairWhite, eamesChairWoodgrain, eamesChairBlackLeather, eamesChairBrownLeather]
//        
//        // Decor
//        let fileCabinet = Model(name: "file_cabinet", category: .decor, scaleCompenation: 0.32/100)
//        let teaPot = Model(name: "teapot", category: .decor, scaleCompenation: 0.32/100)
//        let flowerTulip = Model(name: "flower_tulip", category: .decor, scaleCompenation: 0.32/100)
//        let plateSetDark = Model(name: "plate_set_dark", category: .decor, scaleCompenation: 0.32/100)
//        let plateSetLight = Model(name: "plate_set_light", category: .decor, scaleCompenation: 0.32/100)
//        let pottedFloorPlant = Model(name: "potted_floor_plant", category: .decor, scaleCompenation: 0.32/100)
//        
//        self.all += [fileCabinet, teaPot, flowerTulip, plateSetDark, plateSetLight, pottedFloorPlant]
//        
//        // Lights
//        let floorLampClassic = Model(name: "floor_lamp_classic", category: .light, scaleCompenation: 0.32/100)
//        let floorLampModern = Model(name: "floor_lamp_modern", category: .light, scaleCompenation: 0.32/100)
//        
//        self.all += [floorLampClassic, floorLampModern]
//    }
//    
//    func get(category: ModelCategory) -> [Model] {
//        return all.filter({$0.category == category} )
//    }
//}
