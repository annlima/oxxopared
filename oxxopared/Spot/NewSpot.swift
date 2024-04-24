//
//  NewSpot.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 24/04/24.
//

import SwiftUI
import PhotosUI

struct NewSpot: View {
    
    @State var spot: Spot
    @State private var text: String = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoImage: Image?
    var category = ["Oportunidades", "Servicios", "Artículos de segunda mano", "Cosas perdidas", "medio ambiente"]
    @State private var selectedColor = "Oportunidades"

    
    var body: some View {
        
            ScrollView{
                
                VStack(alignment: .center){
                    
                    Text("Nuevo anuncio")
                        .font(.title)
                        .bold()
                    
                    Spacer(minLength: 50)
                    
                    TextField(
                        "Título de tu anuncio",
                        text: $spot.title
                    )
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 250, maxHeight: 200)
                    
                    
                    Spacer()
                    
                    if let image = photoImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Label("", systemImage: "photo")
                                .foregroundColor(.redMain)
                                .font(.system(size: 100))
                        }
                    }
                    
                    Spacer()
                    
                    
                    TextField(
                        "Describe tu anuncio",
                        text: $spot.text,
                        axis: .vertical
                    )
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                    .padding()
                    
                    HStack() {
                        Text("Categoría")
                        
                        Spacer()
                        
                        Picker("Categoría", selection: $selectedColor) {
                            ForEach(category, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    .padding()
                    
                    TaggerView()
                    
                    
                }
                .onChange(of: photoItem) {
                    Task {
                        if let loaded = try? await photoItem?.loadTransferable(type: Image.self) {
                            photoImage = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
                .padding()
                
        }
    }
}

#Preview {
    NewSpot(spot: Spot(title: "", text: "", category: ""))
}


struct TaggerView: View {
    @State var newTag = ""
    @State var tags = ["añade un tag"]
    @State var showingError = false
    @State var errorString = "x" // Can't start empty or view will pop as size changes

    var body: some View {
        VStack(alignment: .leading) {
            ErrorMessage(showingError: $showingError, errorString: $errorString)
            TagEntry(newTag: $newTag, tags: $tags, showingError: $showingError, errorString: $errorString)
            TagList(tags: $tags)
        }
        .padding()
        .onChange(of: showingError, perform: { value in
            if value {
                // Hide the error message after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showingError = false
                }
            }
        })
      }
}

struct ErrorMessage: View {

    @Binding var showingError: Bool
    @Binding var errorString: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(errorString)
                .foregroundColor(.secondary)
                .padding(.leading, -6)
        }
        .font(.caption)
        .opacity(showingError ? 1 : 0)
        .animation(.easeIn(duration: 0.3), value: showingError)
        }
}

struct TagEntry: View {
    @Binding var newTag: String
    @Binding var tags: [String]
    @Binding var showingError: Bool
    @Binding var errorString: String

    var body: some View {
        HStack {
            TextField("Add Tags", text: $newTag, onCommit: {
                addTag(newTag)
            })
            
            Image(systemName: "plus.circle")
                .foregroundColor(.redMain)
                .onTapGesture {
                    addTag(newTag)
                }
        }
        .onChange(of: newTag, perform: { value in
            if value.contains(",") {
                // Try to add the tag if user types a comma
                newTag = value.replacingOccurrences(of: ",", with: "")
                addTag(newTag)
            }
        })
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }

/// Checks if the entered text is valid as a tag. Sets the error message if it isn't
    private func tagIsValid(_ tag: String) -> Bool {
        // Invalid tags:
        // - empty strings
        // - tags already in the tag array
        let lowerTag = tag.lowercased()
        if lowerTag == "" {
            showError(.Empty)
            return false
        } else if tags.contains(lowerTag) {
            showError(.Duplicate)
            return false
        } else {
            return true
        }
    }

    /// If the tag is valid, it is added to an array, otherwise the error message is shown
    private func addTag(_ tag: String) {
        if tagIsValid(tag) {
            tags.append(newTag.lowercased())
            newTag = ""
        }
    }

    private func showError(_ code: ErrorCode) {
        errorString = code.rawValue
        showingError = true
    }

    enum ErrorCode: String {
        case Empty = "Tag can't be empty"
        case Duplicate = "Tag can't be a duplicate"
    }
}

struct TagList: View {
@Binding var tags: [String]

var body: some View {
    GeometryReader { geo in
        generateTags(in: geo)
            .padding(.top)
    }
}

/// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
private func generateTags(in geo: GeometryProxy) -> some View {
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    return ZStack(alignment: .topLeading) {
        ForEach(tags, id: \.self) { tag in
            Tag(tag: tag, tags: $tags)
                .alignmentGuide(.leading, computeValue: { tagSize in
                    if (abs(width - tagSize.width) > geo.size.width) {
                        width = 0
                        height -= tagSize.height
                    }
                    let offset = width
                    if tag == tags.last ?? "" {
                        width = 0
                    } else {
                        width -= tagSize.width
                    }
                    return offset
                })
                .alignmentGuide(.top, computeValue: { tagSize in
                    let offset = height
                    if tag == tags.last ?? "" {
                        height = 0
                    }
                    return offset
                })
            }
        }
    }
}


struct Tag: View {
    var tag: String
    @Binding var tags: [String]
    @State var fontSize: CGFloat = 20.0
    @State var iconSize: CGFloat = 20.0

    var body: some View {
        HStack {
            Text(tag.lowercased())
                .font(.subheadline)
                .padding(.leading, 5)
                .padding(.trailing, 5)
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .blue, .white)
                .font(.system(size: iconSize, weight: .black, design: .rounded))
                .opacity(0.7)
                .padding(.leading, -5)
        }
        .foregroundColor(.white)
        .font(.caption2)
        .padding(4)
        .background(Color.redMain.cornerRadius(20))
        .padding(4)
        .onTapGesture {
            tags = tags.filter({ $0 != tag })
        }
    }
}
