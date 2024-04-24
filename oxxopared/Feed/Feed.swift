//
//  Feed.swift
//  oxxopared
//
//  Created by iOS Lab on 23/04/24.
//

import SwiftUI

struct Feed: View {
    @State var spots: [Spot] = [Spot.spot1,Spot.spot2,Spot.spot3]
    var body: some View {
        NavigationStack
        {
            ZStack
            {
                Ellipse()
                    .fill(.redMain)
                    .frame(width: 600, height: 300)
 
                    .padding(.top, -300) // Posiciona la elipse hacia arriba para que solo se vea la mitad
                    .padding(.horizontal, 50)
                Text("¡Hola! Ve que hay de nuevo en tu comunidad")
                    .foregroundStyle(.white)
                    .padding(.top, -120)
                    .font(.title)
                    .frame(width: 300, height: 300)
            }
            
            
            ScrollView() {
                ForEach(0 ..< spots.count, id: \.self) { value in
                    SpotView(spot: spots[value])
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
}
