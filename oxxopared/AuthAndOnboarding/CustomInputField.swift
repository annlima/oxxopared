//
//  CustomInputField.swift
//  oxxopared
//
//  Created by Andrea Lima Blanca on 23/04/24.
//
import SwiftUI
struct CustomInputField: View {
    var imageName: String
    var placeholderText: String
    var isSecureField: Bool = false
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
            if isSecureField {
                SecureField(placeholderText, text: $text)
                    .autocapitalization(.none)
            } else {
                TextField(placeholderText, text: $text)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(5)
    }
}
