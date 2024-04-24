//
//  ContentView.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        @State var spots: [Spot] = [Spot.spot1,Spot.spot2,Spot.spot3]
        NewPostView(spots: $spots)
    }
}

#Preview {
    ContentView()
}
