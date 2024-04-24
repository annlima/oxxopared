//
//  User.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 24/04/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var userNombreCompleto: String
    var userEmail: String
    var userPhone: Int
    var userAge: Int
    var userUID: String
    
    enum CodingKeys: CodingKey{
        case id
        case userNombreCompleto
        case userEmail
        case userPhone
        case userAge
        case userUID
    }
}
