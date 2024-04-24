//
//  QrReader.swift
//  oxxopared
//
//  Created by iOS Lab on 24/04/24.
//

import SwiftUI
import Combine

struct QrReader: View {
    @State var scanResult = "No QR code detected"
    @State var showNewPostView = false
    @State var detected = false
    var body: some View {
        VStack
        {
            ZStack
            {
                Rectangle()
                    .fill(.redMain)
                    .frame(width: .infinity, height: 200)
                Text("Escanea el código QR de tu ticket de compra para poder publicar tu anuncio a la comunidad")
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            
            
            QRScanner(result: $scanResult)

            NavigationLink(
                            destination: NewPostView(),
                            isActive: $showNewPostView,
                            label: { EmptyView() }
                        )
                        .hidden()
            
        }
        .ignoresSafeArea()
        .onReceive(Just(scanResult)) { result in
                   if result == "Hello :)" || detected{
                       detected = true
                       showNewPostView = true
                   }
               }
        

        
    }
    
    
}

#Preview {
    QrReader()
}
