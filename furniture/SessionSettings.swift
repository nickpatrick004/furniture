//
//  SessionSettings.swift
//  furniture
//
//  Created by Nick Patrick on 12/26/21.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiuserEnabled: Bool = false
    
    
}
