//
//  Onboarding.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.
//
//
import SwiftUI
import UserNotifications
import CoreLocation

struct Onboarding: View {
    @State private var selectedIndex = 0
    @State private var onboardingCompleted = false

    var body: some View {
        if onboardingCompleted{
            MainFeedView()
                .environmentObject(SpotStore())
        }
        else
        {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("RedMain").opacity(0.7), Color("RedMain").opacity(0.9), Color("RedMain")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                TabView(selection: $selectedIndex) {
                    WelcomeTab().tag(0)
                    ProfilePhotoTab(selectedIndex: $selectedIndex).tag(1)
                    NotificationsTab(selectedIndex: $selectedIndex).tag(2)
                    LocationPermissionTab().tag(3)
                    ReportingTab(selectedIndex: $selectedIndex).tag(4)
                    GoTab(onboardingCompleted: $onboardingCompleted).tag(5)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<6) { index in
                            Rectangle()
                                .frame(width: selectedIndex == index ? 20 : 8, height: 8)
                                .foregroundColor(selectedIndex == index ? Color.white : Color.gray)
                                .cornerRadius(4)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Onboarding()
                .preferredColorScheme(.light)
        }
    }
}
// MARK: - LocationPermissionTab
struct LocationPermissionTab: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "location.fill")
                .font(.system(size: 190, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, -20)
            Text("Permitir acceso a ubicación")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("Necesitamos acceso a tu ubicación para que puedas encontrar tu Oxxo más cercano.")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading, .bottom], 50)
            Spacer()
            Button("Activar ubicación") {
                locationManager.requestLocationAuthorization()
            }
            .frame(width: 320, height: 50)
            .font(.system(size: 20, weight: .bold))
            .background(Color.white)
            .foregroundColor(Color("RedMain"))
            .cornerRadius(10)
            .padding(.bottom, 50)
        }
    }
}
// MARK: - WelcomeTab
struct WelcomeTab: View {
    var body: some View {
        VStack {
            Image("oxxo")
                .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 300, height: 378)
                  .shadow(color: .black, radius: 30, x: 0, y: 2)
            Text("Bienvenido")
                .font(.system(size: 43, weight: .bold)) // Hacer el título un poco más grande
                .foregroundColor(.white) // Color del texto
                .padding(.horizontal, 10)
                .padding(.top, -10) // Espacio reducido arriba del título
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("Anuncios a tu alcance, ahorros en tu bolsillo.")
                .font(.system(size: 20))
                .foregroundColor(.white) // Color del texto
                .bold()
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading, .bottom], 50)
            
        }
    }
}


// MARK: - GoTab
struct GoTab: View {
    @Binding var onboardingCompleted: Bool
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "megaphone")
                .font(.system(size: 180, weight: .bold))
                .rotationEffect(.degrees(-45))
            Text("¡Estás listo!")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.top, 40)
                .padding(.bottom, 1)
            Button("Comenzar a participar") {
                onboardingCompleted = true
                        }
                            .frame(width: 320, height: 75)
                            .font(.system(size: 25, weight: .bold))
                            .background(Color.white)
                            .foregroundColor(Color("RedMain"))
                            .cornerRadius(10)
                            .padding(.top, 50)
                        Spacer()
            
        }
        
        .foregroundColor(.white)
    }
}

// MARK: - Notifications
struct NotificationsTab: View {
    @Binding var selectedIndex: Int
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 190, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, -20)
            Text("Activar notificaciones")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .padding([.horizontal], 10)
                .padding(.top, 20)
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("Mantente al día con los últimos productos y ofertas activando las notificaciones.")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading, .bottom], 50)
            Spacer()
            Button("Permitir notificaciones") {
                requestNotifications()
            }
            .frame(width: 320, height: 50)
            .font(.system(size: 20, weight: .bold))
            .background(Color.white)
            .foregroundColor(Color("RedMain"))
            .cornerRadius(10)
            .padding(.bottom, 50)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    alertTitle = "Notificaciones activadas"
                    alertMessage = "¡Gracias por activar las notificaciones! Ahora recibirás las últimas actualizaciones directamente."
                } else {
                    alertTitle = "Notificaciones Desactivadas"
                    alertMessage = "Has desactivado las notificaciones. Puedes cambiar esto en cualquier momento desde los ajustes de tu dispositivo."
                }
                showingAlert = true
                selectedIndex = (selectedIndex) % 6
            }
        }
    }
}

// MARK: - Report posts
struct ReportingTab: View {
    @Binding var selectedIndex: Int
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.bubble")
                .font(.system(size: 190, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, -20)
            Text("Reportar publicaciones")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .padding([.horizontal], 10)
                .padding(.top, 20)
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("En caso de que veas una publicación que no cumple con las políticas de nuestra app y el código de ética, repórtala.")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading, .bottom], 50)
            Spacer()
        }
    }
}

// MARK: - ProfilePhoto
struct ProfilePhotoTab: View {
    @Binding var selectedIndex: Int
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 190, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, -20)
            Text("Añadir foto de perfil")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .padding([.horizontal], 10)
                .padding(.top, 20)
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("Subir una foto puede ayudar a tu comunidad a reconocerte.")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading, .bottom], 50)
            Spacer()
            Button("Seleccionar foto") {
                showingImagePicker = true
            }
            .frame(width: 320, height: 50)
            .font(.system(size: 20, weight: .bold))
            .background(Color.white)
            .foregroundColor(Color("RedMain"))
            .cornerRadius(10)
            .padding(.bottom, 50)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $inputImage)
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        DispatchQueue.main.async {
            selectedIndex = (selectedIndex + 1) % 4
        }
    }
}


// MARK: - Reusable View Template
func tabViewTemplate(imageName: String, title: String, description: String) -> some View {
    VStack {
        Spacer()
        Image(systemName: imageName)
            .font(.system(size: 190, weight: .bold))
            .foregroundColor(.white)
            .padding(.bottom, -20)

        Text(title)
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(.white) // Color del texto
            .padding(.horizontal, 10)
            .padding(.top, 20) // Espacio reducido arriba del título
            .padding(.bottom, 1)
            .multilineTextAlignment(.center)
        Text(description)
            .font(.system(size: 20))
            .foregroundColor(.white) // Color del texto
            .bold()
            .multilineTextAlignment(.center)
            .padding([.trailing, .leading, .bottom], 50)
        Spacer()
    }
    .tabItem {
        Image(systemName: "circle.fill")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
