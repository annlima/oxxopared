//
//  LogInView.swift
//  echoChallenges
//
//  Created by Andrea Lima Blanca on 22/02/24.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = "Error al iniciar sesión"
    @State private var shouldNavigate = false
    @State var isLoading: Bool = false
    @State var showError: Bool = false
    
    @AppStorage ("log_status") var logstatus: Bool = false
    @AppStorage ("user_name") var userNameStored: String = ""
    @AppStorage ("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") var profileURL: URL?
    
    var body: some View {
        NavigationStack{
            VStack {
                AuthHeaderView(title1: "Hola,", title2: "bienvenido de nuevo.")
                
                VStack(spacing: 40) {
                    CustomInputField(imageName: "envelope",
                                     placeholderText: "Correo electrónico",
                                     isSecureField: false,
                                     text: $email)
                    CustomInputField(imageName: "lock",
                                     placeholderText: "Contraseña",
                                     isSecureField: true, // Aquí se necesita para el campo de contraseña
                                     text: $password)
                }
                .padding(.horizontal, 32)
                .padding(.top, 44)
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        PasswordResetView()
                    } label: {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("RedMain") .opacity(0.9))
                            .padding(.top)
                            .padding(.trailing, 24)
                    }
                }
                NavigationLink(destination: MainFeedView(), isActive: $shouldNavigate) { EmptyView() }
                Button {
                    print("Inicia sesión")
                    loginUser()
                } label: {
                    Text("Inicia sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color("RedMain") .opacity(0.9))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarHidden(true)
                } label: {
                    HStack {
                        Text("¿Aún no tienes un cuenta?")
                            .font(.footnote)
                        
                        Text("Regístrate")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
                .foregroundColor(Color.redMain.opacity(0.9))
                
                NavigationLink(
                    destination: Onboarding(),
                    isActive: $shouldNavigate,
                    label: {
                        EmptyView()
                    })
                    .hidden()
            }
            .overlay(content: {
                capaCarga(show:$isLoading)
            })
            .alert(errorMessage, isPresented: $showError, actions:{})
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func loginUser(){
            isLoading=true
            closeKeyboard()
            Task{
                do{
                    try await Auth.auth().signIn(withEmail:email, password: password)
                    print("User Found")
                    try await fetchUser()
                }catch{
                    await setError(error)
                }
            }
        }
    
    func fetchUser()async throws{
            guard let userID = Auth.auth().currentUser?.uid else{return}
            let user = try await Firestore.firestore().collection("User").document(userID).getDocument(as: User.self)
            await MainActor.run(body:{
                userUID = userID
                userNameStored = user.userNombreCompleto
                logstatus=true
                shouldNavigate = true
            })
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
            LoginView()
    }
}
