//
//  SpotManager.swift
//  oxxopared
//
//  Created by iOS Lab on 23/04/24.
//

import Foundation
import SwiftUI
import UIKit

struct SpotManager: UIViewRepresentable
{
    let text: String
    func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.dataDetectorTypes = .phoneNumber // Detectar números de teléfono como enlaces
            textView.text = text
            textView.font = UIFont.preferredFont(forTextStyle: .body) // Usar la fuente preferida para el estilo de texto del cuerpo
            textView.textAlignment = .center // Alinear el texto a la izquierda
            
            // Limitar el ancho del textView
            textView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 32).isActive = true
            
            return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
