//
//  SpotView.swift
//  oxxopared
//
//  Created by iOS Lab on 23/04/24.
//

import SwiftUI

struct SpotView: View {
    let spot: Spot
    var body: some View {
                
            VStack
            {
                
                Text(spot.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                    .padding()
                    
                buildTextView()
                    .frame(width: 250)
                
                
                    
                if let image = spot.image {
                    image
                        .resizable()
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200,height: 200)
                        .padding()
                        
                }
            }
            .padding(.bottom)
            .border(Color.black)
        
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
        
        return VStack {
            ForEach(views.indices, id: \.self) { index in
                views[index]
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
    }
    
    private func detectPhoneNumber(_ text: String) -> String? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        return matches?.first?.phoneNumber
    }}


#Preview {
    SpotView(spot: Spot.spot1)
}
