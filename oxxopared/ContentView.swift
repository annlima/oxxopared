//
//  ContentView.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.presentations) private var presentations
    
    
    var body: some View {
        
        Group {
            if authModel.user != nil {
                MainFeedView()
            } else {
                LoginView()
            }
        }.onAppear {
            authModel.listenToAuthState()
        }
    }
}

#Preview {
    ContentView()
}
