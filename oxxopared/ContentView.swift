//
//  ContentView.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    
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
