//
//  Utils.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 23/04/24.
//

import Foundation
import SwiftUI

struct CustomeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 70)
            .padding(.vertical, 10)
            .background(Color(.redMain))
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.redMain))
            )
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
