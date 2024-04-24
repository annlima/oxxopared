//
//  SpotView.swift
//  oxxopared
//
//  Created by iOS Lab on 23/04/24.
//

import SwiftUI

struct SpotView: View {
    let spot: Spot
    var body: some View {
                
            VStack
            {
                
                Text(spot.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 250)
                    .padding()
                
                Text(spot.text)
                    .frame(width: 250)
                    .padding()
                
                if let image = spot.image {
                    image
                        .resizable()
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200,height: 200)
                        .padding()
                        
                }
            }
            .padding(.bottom)
            .border(Color.black)
        
    }
}

#Preview {
    SpotView(spot: Spot.spot1)
}
