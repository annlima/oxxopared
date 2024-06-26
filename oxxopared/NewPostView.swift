//
//  NewPostView.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 24/04/24.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct PostData {
    var profilePicture: Image
    var username: String
    var post: Image
    var title: String
    var caption: String
    var numberLikes: Int
}

struct NewPostView: View {

    @EnvironmentObject var spotStore: SpotStore // EnvironmentObject for the spots

    @Binding var navigationPath: NavigationPath
    @State private var image: Data?
    @State private var item: PhotosPickerItem?
    @State var titleText: String = ""
    @State var caption: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    var categories = ["Oportunidades", "Servicios", "Artículos de segunda mano", "Cosas perdidas", "Medio ambiente"]
    @State private var selectedCategory = "Oportunidades"
    let modelURL = Bundle.main.url(forResource: "IllegalRelated", withExtension: "mlmodelc")!
    @State var validImage = false;
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var alertMessage: String = ""
    @State var showingAlert = false
    @State private var navigationActive = false

    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var body: some View {

        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text("Nueva publicación")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("RedMain"))

                    PhotosPicker(selection: $item, matching: .images, label: {
                        if let data = image, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.9, height: screenWidth * 0.75)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        } else {
                            ZStack {
                                Rectangle()
                                    .frame(width: screenWidth * 0.9, height: screenWidth * 0.75)
                                    .foregroundColor(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 60)
                                    .foregroundColor(.gray)
                            }
                        }
                    })

                    .onChange(of: item) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                self.image = data
                                if let uiImage = UIImage(data: data) {
                                    self.selectedImage = uiImage
                                }
                            }
                        }
                    }

                    TextField("Agrega un título", text: $titleText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack {
                        Text("Agrega una descripción")
                            .foregroundColor(.black.opacity(0.3)) // Increased opacity for better visibility
                            .padding(.horizontal)
                        Spacer()
                    }

                    TextEditor(text: $caption) // Changed to caption
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 100) // You might want to specify a height
                        .padding(.horizontal)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1)) // Added border for better visibility
                        .padding(.horizontal)


                    VStack {
                        TaggerView()
                            .padding()
                            .padding(.bottom, 40)

                        HStack {
                            Text("Categoría")

                            Picker("Please choose a color", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            .accentColor(.redMain)
                        }
                    }
                    
                    NavigationLink(
                        destination: PromosView(navigationPath: $navigationPath),
                                    isActive: $navigationActive,
                                    label: { EmptyView() }
                                )

                    Button("Publicar") {
                        if let uiImage = selectedImage {
                            if let pixelBuffer = pixelBufferConv(from:uiImage) {
                                // Realiza la predicción con el pixelBuffer
                                do {
                                    let config = MLModelConfiguration()
                                    let model = try IllegalRelated(configuration: config)

                                    let prediction = try model.prediction(image: pixelBuffer)
                                    // Usa el resultado de la predicción según sea necesario
                                    if prediction.target == "Legal"
                                    {
                                        let newImage: Image?
                                        if let selectedImage = selectedImage {
                                            newImage = Image(uiImage: selectedImage)
                                            navigationActive = spotStore.addSpot(title: titleText, image: newImage, text: caption, category: selectedCategory)
                                        } else {
                                            //newImage = nil  // Keep newImage as nil if there's no selected image
                                            
                                            navigationActive = spotStore.addSpot2(title: titleText, text: caption, category: selectedCategory)
                                        }
                                    }
                                    else
                                    {
                                        showingAlert = true
                                        alertMessage = "La imagen que intentas publicar no es permitida."
                                        
                                    }
                                } catch {
                                    print("Error al hacer la predicción: \(error)")
                                }
                            } else {
                                print("Error: No se pudo convertir la imagen a pixelBuffer")
                            }
                           
                        } else {
                            // Provide user feedback about the error
                            //print("Error: No image selected")
                            
                            navigationActive = spotStore.addSpot2(title: titleText, text: caption, category: selectedCategory)
                        }
                        
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.redMain)
                    .cornerRadius(10)
                    .disabled(titleText.isEmpty || caption.isEmpty || selectedCategory.isEmpty)

                }
            }
            
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    

    func pixelBufferConv(from image: UIImage) -> CVPixelBuffer? {
        let size = image.size
        let cgImage = image.cgImage!

        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32ARGB,
            options as CFDictionary,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        let data = CVPixelBufferGetBaseAddress(buffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: data,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )

        guard let ctx = context else {
            return nil
        }

        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        CVPixelBufferUnlockBaseAddress(buffer, [])

        return pixelBuffer
    }


    func setError(_ error: Error) async {
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }

}

extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, attrs as CFDictionary, &pixelBuffer)

        guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        guard let cgImage = cgImage, let cgContext = context else {
            return nil
        }

        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }


}

struct NewPostView_Previews: PreviewProvider {
    @State static var posts: [PostData] = []

    static var previews: some View {
        @State var navigationPath = NavigationPath()
        NewPostView(navigationPath: $navigationPath)
        
            .environmentObject(SpotStore())
    }
}
