//
//  MainTabBarItem.swift
//  oxxopared
//
//  Created by Dicka J. Lezama on 23/04/24.
//

import Foundation
import SwiftUI

enum MainTabBarItem: Hashable { // Items
    case announcements, ar, profile
    
    var imageName: String {
        switch self {
        case .announcements: return "megaphone"
        case .ar: return "plus.app"
        case .profile: return "person"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .announcements: return "megaphone.fill"
        case .ar: return "plus.app.fill"
        case .profile: return "person.fill"
        }
    }
    
    var color: Color {
        return .red
    }
    
    var isStatic: Bool {
        return self == .ar
    }
}
