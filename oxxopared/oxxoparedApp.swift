//
//  oxxoparedApp.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // Escucha cambios en el estado de autenticación
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("Usuario logueado: \(user.uid)")
                // Aquí puedes restaurar el estado de la sesión en tu aplicación
            } else {
                print("Usuario no logueado")
                // Manejar usuario no logueado
            }
        }

        return true
    }
}

@main
struct OxxoParedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
