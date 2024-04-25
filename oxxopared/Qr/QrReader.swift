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
    @Binding var navigationPath: NavigationPath
    
    @Environment(\.presentations) private var presentations
    
    var body: some View {
        NavigationStack{
            VStack
            {
                ZStack
                {
                    ZStack{
                        Rectangle()
                            .fill(.redMain)
                            .frame(maxWidth: .infinity)
                    }.padding(.top, -23)
                    
                    Text("Escanea el código QR de tu ticket de compra para poder publicar tu anuncio a la comunidad")
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                .padding(.top, 23)
                
                QRScanner(result: $scanResult)
                
                
                /*NavigationLink(
                    destination: NewPostView(navigationPath: $navigationPath),
                    isActive: $showNewPostView,
                    label: { EmptyView() }
                )
                .hidden()*/
                
            }
        }
        .sheet(isPresented: $showNewPostView) {
            NewPostView(navigationPath: $navigationPath)
                .environmentObject(SpotStore())
                .environment(\.presentations, presentations + [$showNewPostView])
        }
        .ignoresSafeArea()
        .onReceive(Just(scanResult)) { result in
           if result == "Hello :)" {
               detected = true
               showNewPostView = true
           }
       }
        
    }
    
}

/*#Preview {
    @State var navigationPath = NavigationPath()
    QrReader(navigationPath: NavigationPath())
}*/


struct PresentationKey: EnvironmentKey {
    static let defaultValue: [Binding<Bool>] = []
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey] }
        set { self[PresentationKey] = newValue }
    }
}
