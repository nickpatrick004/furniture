//
//  View+Extensions.swift
//  furniture
//
//  Created by Nick Patrick on 12/26/21.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
