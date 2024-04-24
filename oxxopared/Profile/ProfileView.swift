import SwiftUI
import FirebaseStorage
import MapKit
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    
    @State private var myProfile: User?
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var nombreCompleto: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logstatus: Bool = false
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    let profile: Profile = .fer
    @State var text: String = ""
    @State private var alertText = ""
    @State private var showingBadge = false
    
    @State private var myPlace: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.04802, longitude: -98.29617) // Default value
    @State private var showMenu = false // For showing the action sheet
    @State private var navigateToSettings = false // To control navigation to the settings view
    @State private var navigateToLogIn = false // To control navigation to the login view
    @State private var badgeEarned = false
    
    var body: some View {
                          
        NavigationStack {
            ScrollView {
                ZStack(alignment: .topTrailing) {
                    
                    
                    
                    VStack{
                        
                        // Profile Information
                        VStack (alignment: .center, spacing: 10) {
                            
                            // Profile picture
                            profile.profilePhoto
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(.circle)
                                .overlay(
                                    Circle()
                                        .stroke(.white, lineWidth: 4)
                                )
                                .padding(4)
                                .background {
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 4)
                                        .background(Circle().foregroundColor(.white))
                                        .frame(width: 150, height: 150)
                                        .shadow(radius: 20) // Adds a shadow for depth
                                }
                            
                                .padding(.top, 70)
                            
                            Text(profile.name)
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                            
                            
                        }
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .background(Color.redMain.opacity(0.9))
                        
                        
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            
                            Text("Mis insignias")
                                .font(.system(.title2, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 8) {
                                    
                                    ForEach(0 ..< profile.badges.count, id: \.self) { value in
                                        
                                        VStack {
                                            getBadge(type: profile.badges[value], width: 60)
                                                .frame(width: 60, height: 60)
                                                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                                .alert(self.text, isPresented: $showingBadge) {
                                                    Button("OK", role: .cancel) { }
                                                    
                                                }
                                                .onTapGesture(perform: {
                                                    self.text = getAboutBadge(type: profile.badges[value])
                                                    self.showingBadge.toggle()
                                                })
                                            
                                            Text(getTypeBadge(type: profile.badges[value]))
                                                .font(.caption)
                                                .bold()
                                                .multilineTextAlignment(.center)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(width: 90)
                                            
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            Text("Mis anuncios")
                                .font(.system(.title2, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(0 ..< profile.spots!.count, id: \.self) { value in
                                SpotView(spot: profile.spots![value])
                                    .padding()
                            }
                            .padding()
                        }
                        .padding()
                        Spacer()
                            
                    }
                    
                    Menu {
                        Button {
                            self.navigateToSettings = true
                        } label: {
                            Text("Configuración")
                        }
                        
                        Button{
                            self.navigateToLogIn = true
                        } label: {
                            Text("Cerrar sesión")
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .rotationEffect(Angle(degrees: 90))
                            .foregroundColor(.black)
                    }
                    .frame(width: 40, height: 40)
                    .background{
                        Color.white
                            .opacity(0.9)
                    }
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                    .padding(.trailing, 15)
                    
                }
                
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $navigateToLogIn) {
                LoginView()
            }
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
    
    func fetchUserData()async{
            guard let userUID = Auth.auth().currentUser?.uid else{return}
            guard let user = try? await Firestore.firestore().collection("User").document(userUID).getDocument(as: User.self) else{return}
            await MainActor.run(body: {
                myProfile = user
            })
        }
    
    func logOutUser(){
            try? Auth.auth().signOut()
            userUID = ""
            nombreCompleto = ""
            logstatus = false
        }
        
        func deleteAccount(){
            isLoading = true
            Task{
                do{
                    guard let userUID = Auth.auth().currentUser?.uid else{return}
                    // Step 1: First Deleting Profile Image From Storage
                    let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                    try await reference.delete()
                    // Step 2: Deleting Firestore User Document
                    try await Firestore.firestore().collection("User").document(userUID).delete()
                    try await Auth.auth().currentUser?.delete()
                    logstatus = false
                }catch{
                    await setError(error)
                }
            }
        }
        
        func setError(_ error: Error)async{
            await MainActor.run(body: {
                isLoading = false
                errorMessage = error.localizedDescription
                showError.toggle()
            })
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
