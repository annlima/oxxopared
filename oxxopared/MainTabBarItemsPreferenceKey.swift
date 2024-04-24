//
//  MainTabBarItemsPreferenceKey.swift
//  oxxopared
//
//  Created by Dicka J. Lezama on 23/04/24.
//

import Foundation
import SwiftUI

//reference key
struct MainTabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [MainTabBarItem] = []
    
    static func reduce(value: inout [MainTabBarItem], nextValue: () -> [MainTabBarItem]) {
        value += nextValue()
    }
}

struct MainTabBarItemViewModifier: ViewModifier {
    let tab: MainTabBarItem
    @Binding var selection: MainTabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0: 0.0)
            .preference(key: MainTabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func mainTabBarItem (tab: MainTabBarItem, selection: Binding<MainTabBarItem>) -> some View {
        self
            .modifier(MainTabBarItemViewModifier(tab: tab, selection: selection))
    }
}
