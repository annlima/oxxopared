//
//  PasswordReset.swift
//  echo
//
//  Created by Andrea Lima Blanca on 26/02/24.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    @State private var email = ""
    @State var isLoading: Bool = false
    @State var showError: Bool = false
    @State private var errorMessage = "Error al iniciar sesión"
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Recuperación de", title2: "contraseña")
            
            VStack(spacing: 40) {
                CustomInputField(imageName: "envelope",
                                 placeholderText: "Ingrese correo electrónico",
                                 isSecureField: false,
                                 text: $email)
            }
            .padding(.horizontal, 32)
            .padding(.top, 44)
            
            Text("Ingresa tu número telefónico y te enviaremos instrucciones para restablecer tu contraseña.")
                .foregroundColor(Color("ColorPrincipal"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Button {
                // Aquí iría la lógica para manejar la solicitud de recuperación de contraseña
                print("Solicitud de recuperación de contraseña enviada")
            } label: {
                Text("Enviar solicitud")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color("RedMain") .opacity(0.9))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            NavigationLink {
                LoginView()
                    .navigationBarHidden(true)
            } label: {
                Text("Volver al inicio de sesión")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("RedMain") .opacity(0.9))
            }
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading=false
        })
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
