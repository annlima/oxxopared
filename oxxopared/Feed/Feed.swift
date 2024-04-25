//
//  Feed.swift
//  oxxopared
//
//  Created by iOS Lab on 23/04/24.
//

import SwiftUI

struct Feed: View {
    @EnvironmentObject var spotStore: SpotStore
    //@State var spots: [Spot] = [Spot.spot1,Spot.spot2,Spot.spot3, Spot.spot4]
    
    var body: some View {
        NavigationStack
        {
            ZStack
            {
                Ellipse()
                    .fill(Color.redMain)
                    .frame(width: 600, height: 300)
                    .padding(.top, -235) // Posiciona la elipse hacia arriba para que solo se vea la mitad
                    .padding(.horizontal, 50)
                
                Text("¡Hola! Ve que hay de nuevo en tu comunidad")
                    .foregroundStyle(.white)
                    .padding(.top, -70)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(width: 300, height: 300)
                    .padding(.leading)
                    .multilineTextAlignment(.center)
            }
            
            
            ScrollView() {
                ForEach(spots) { spot in
                    SpotView(spot: spot)
                        .padding()
                }
            }
            .padding(.top,-120)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Feed()
        .environmentObject(SpotStore())
}
