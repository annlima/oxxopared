//  RegisterView.swift
//  echo
//
//  Created by Andrea Lima Blanca on 25/02/24.
//
import SwiftUI
import FirebaseAuth

struct iOSCheckboxToggleStyle: View {
    @Binding var checked: Bool

        var body: some View {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
                .onTapGesture {
                    self.checked.toggle()
                }
        }
    }

struct RegistrationView: View {
    @State private var email = ""
    @State private var phonenumber = ""
    @State private var fullname = ""
    @State private var age = ""
    @State private var password = ""
    @State private var checked = false
    @State private var errorMessage = "Error al registrarse"
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldNavigate = false
    var body: some View {
        NavigationView{
            VStack {
                AuthHeaderView(title1: "Empecemos,", title2: "crea tu cuenta.")
                VStack(spacing: 20) {
                    CustomInputField(imageName: "person",
                                     placeholderText: "Nombre completo",
                                     isSecureField: false,
                                     text: $fullname)
                    CustomInputField(imageName: "envelope",
                                     placeholderText: "Correo electrónico",
                                     isSecureField: false,
                                     text: $email)
                    CustomInputField(imageName: "phone",
                                     placeholderText: "Número de teléfono",
                                     isSecureField: false,
                                     text: $phonenumber)
                    CustomInputField(imageName: "number",
                                     placeholderText: "Edad",
                                     isSecureField: false, 
                                     text: $age)
                    
                    CustomInputField(imageName: "lock",
                                     placeholderText: "Contraseña",
                                     isSecureField: true,
                                     text: $password)
                    
                    HStack {
                        iOSCheckboxToggleStyle(checked: $checked)
                        NavigationLink(destination: TermsAndConditions()) {
                            Text("Estoy de acuerdo con los términos y condiciones")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("RedMain") .opacity(0.9))
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, -40)
                NavigationLink(destination: Onboarding(), isActive: $shouldNavigate) { EmptyView() }
                Button {
                    register()
                    //self.shouldNavigate = true
                } label: {
                    Text("Regístrate")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color("RedMain") .opacity(0.9))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        NavigationLink(destination: LoginView()) {
                            Text("¿Ya tienes cuenta? Inicia sesión")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("RedMain") .opacity(0.9))
                        }
                    }
                }
                .padding(.bottom)
            }
            .ignoresSafeArea()
        }
    }
    
    func register() {

        // Firebase registration
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            // Registration successful, handle next steps
            print("User registered successfully")
            self.shouldNavigate = true
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
            RegistrationView()
    }
}
