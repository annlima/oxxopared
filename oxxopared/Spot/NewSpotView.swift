//
//  NewSpotView.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 24/04/24.
//

import SwiftUI
import PhotosUI

struct NewSpotView: View {
    
    @State private var text: String = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoImage: Image?
    
    var categories = ["Oportunidades", "Servicios", "Artículos de segunda mano", "Cosas perdidas", "Medio ambiente"]
    @State private var selectedColor = "Oportunidades"
    
    @State private var spot = Spot(title: "", text: "", category: "")
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center) {
                
                Text("Nuevo anuncio")
                    .font(.title)
                    .bold()
                
                Spacer(minLength: 50)
                
                TextField("Título del anuncio", text: $spot.title)
                    .font(.title)
                
                
                if let image = photoImage {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                } else {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label("", systemImage: "photo")
                            .foregroundColor(.redMain)
                            .font(.system(size: 100))
                    }
                }
                
                TextField("Describe tu anuncio", text: $spot.text, axis: .vertical)
                    .font(.title2)
                
                TaggerView()
                
            }
            .onChange(of: photoItem) {
                Task {
                    if let loaded = try? await photoItem?.loadTransferable(type: Image.self) {
                        photoImage = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    NewSpotView()
}
