//
//  AnimatedImageView.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 24/04/24.
//
import SwiftUI

struct AnimatedImageView: View {
    @State private var showImage = false
    @State private var shouldNavigate = false

    var body: some View {
        VStack {
            Spacer()
            AuthHeaderView(title1: "Te has conectado", title2: "a tu tarjeta Spin exitosamente")
                .multilineTextAlignment(.center)
            Image("spin")
                .resizable()
                .scaledToFit()
                .frame(width: showImage ? 300 : 100, height: showImage ? 300 : 100)
                
                .shadow(radius: 10)
                .scaleEffect(showImage ? 1 : 0.3)
                .opacity(showImage ? 1 : 0)
                .animation(.easeInOut(duration: 1.5), value: showImage)
                .onAppear {
                    self.showImage.toggle()
                }

            Spacer()
            NavigationLink(destination: Onboarding(), isActive: $shouldNavigate) { EmptyView() }

            Button(action: {
                self.shouldNavigate = true
                print("Botón continuar presionado.")
            }) {
                Text("Continuar")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("RedMain"))
                    .cornerRadius(8)
                    .shadow(radius: 10)
            }
            .padding(.bottom, 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
      
}

struct AnimatedImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedImageView()
    }
}
