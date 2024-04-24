//
//  ReusableProfileContent.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 24/04/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    @State private var fetchedPosts: [Spot] = []
    var user: User
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 20) {
                HStack(spacing: 20) {
                    WebImage(url: user.userProfileURL)
                    { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                        } placeholder: {
                                Rectangle().foregroundColor(.gray)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.userNombreCompleto)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .hAlign(.leading)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                Text("Mis Anuncios")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                //ReusableSpotsView(basedOnUID: true, uid: user.userUID, spots: $fetchedPosts)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding(10)
        }
    }
}
