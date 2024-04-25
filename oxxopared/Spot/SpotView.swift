import SwiftUI

struct SpotView: View {
    let spot: Spot
    @State private var reported = false

    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text(spot.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .padding(.top)

                    buildTextView()
                        .frame(width: 250)
                    
                    if let image = spot.image {
                        image
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                }
                .padding(.bottom)
                .background(Color.white)
                .cornerRadius(10)
                .background(VisualEffect())
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                
            }
            
            // Report Button
            Button(action: {
                reportSpot()
            }) {
                Image(systemName: "exclamationmark.bubble")
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .offset(x: 110, y: -30) // Adjust the offset as needed
        }
        .overlay(
                   TapeView()
                       .rotationEffect(.degrees(-1)),
                       alignment: .top
                   )
        .padding()
        .alert(isPresented: $reported) {
            Alert(title: Text("Reported"), message: Text("You have already reported this post. We will take it into account."), dismissButton: .default(Text("OK")))
        }
    }

    private func reportSpot() {
        reported = true
    }

    private func buildTextView() -> some View {
            let words = spot.text.split(separator: " ")
            var views: [AnyView] = []
            var currentString = ""
            
            for word in words {
                if let phoneNumber = detectPhoneNumber(String(word)) {
                    views.append(AnyView(Text(currentString)))
                    currentString = ""
                    views.append(AnyView(Link(destination: URL(string: "tel://\(phoneNumber)")!) {
                        Text(phoneNumber)
                            .foregroundColor(.blue)
                           
                            
                    }))
                } else {
                    
                    currentString = currentString + word + " "
                }
            }
            views.append(AnyView(Text(currentString)))
        
        return VStack(alignment: .leading) {
            ForEach(0..<views.count, id: \.self) { index in
                views[index]
            }
        }
        .padding()
    }

    private func detectPhoneNumber(_ text: String) -> String? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        return matches?.first?.phoneNumber
    }

    private func callNumber(_ phoneNumber: String) {
        guard let phoneCallURL = URL(string: "tel://\(phoneNumber)") else { return }
        UIApplication.shared.open(phoneCallURL)
    }
}
struct VisualEffect: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
    }
}

struct TapeView: View {
        var body: some View {
            IrregularTapeShape()
                .fill(Color.red.opacity(0.5)) // Set the color and opacity for the tape
                .frame(height: 20) // Set the appropriate height for the tape
                .edgesIgnoringSafeArea(.horizontal)
        }
    }


struct IrregularTapeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from the bottom left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Irregular left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.05, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY))
        
        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY))
        
        // Irregular right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // Close the path back to the bottom left
        path.closeSubpath()
        
        return path
    }
}

// Ensure you define `Spot` and provide an image or remove the optional Image if not used

struct SpotView_Previews: PreviewProvider {
    static var previews: some View {
        SpotView(spot: Spot.spot1)
    }
}
