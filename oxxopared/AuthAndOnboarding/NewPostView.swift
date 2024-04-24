import SwiftUI
import PhotosUI

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
    @Binding var posts: [PostData]
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var body: some View {
        NavigationStack {
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
                        }
                    }
                }

                TextField("Agrega un título", text: $titleText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("Agrega una descripción", text: $titleText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                

                Button("Publicar") {
                    if let imageData = image, let uiImage = UIImage(data: imageData) {
                        let newPostData = PostData(
                            profilePicture: Image(systemName: "person.fill"),
                            username: "username",
                            post: Image(uiImage: uiImage),
                            title: titleText,
                            caption: caption,
                            numberLikes: 0
                        )
                        posts.append(newPostData)
                        dismiss()
                        
                    } else {
                        // Provide user feedback about the error
                        print("Error: No image selected")
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
                
            }
            .padding()
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    @State static var posts: [PostData] = []
    
    static var previews: some View {
        NewPostView(posts: $posts)
    }
}
