import SwiftUI
import PhotosUI
import CoreML

struct PostData {
    var profilePicture: Image
    var username: String
    var post: Image
    var title: String
    var caption: String
    var numberLikes: Int
}

struct NewPostView: View {
    
    @State private var image: Data?
    @State private var item: PhotosPickerItem?
    @State var titleText: String = ""
    @State var caption: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    var categories = ["Oportunidades", "Servicios", "Artículos de segunda mano", "Cosas perdidas", "Medio ambiente"]
    @State private var selectedCategory = "Oportunidades"
    
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
                    HStack
                    {
                        Text("Agrega una descripción")
                            .foregroundStyle(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/.opacity(0.3))
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    TextEditor(text: $titleText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .border(Color.black.opacity(0.1))
                        .padding(.horizontal)
                    
                    Spacer()
                    
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
                    
                    Button("Publicar") {
                        if let uiImage = selectedImage {
                            if let pixelBuffer = pixelBufferConv(from:uiImage) {
                                // Realiza la predicción con el pixelBuffer
                                do {
                                    let config = MLModelConfiguration()
                                    let model = try IllegalRelated(configuration: config)
                                    
                                    let prediction = try model.prediction(image: pixelBuffer)
                                    // Usa el resultado de la predicción según sea necesario
                                } catch {
                                    print("Error al hacer la predicción: \(error)")
                                }
                            } else {
                                print("Error: No se pudo convertir la imagen a pixelBuffer")
                            }
                        } else {
                            // Provide user feedback about the error
                            print("Error: No image selected")
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.redMain)
                    .cornerRadius(10)
                    
                }
            }
            .padding()
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
        NewPostView()
    }
}
