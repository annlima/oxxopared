//
//  Spot.swift
//  oxxopared
//
//  Created by Azuany Mila Cerón on 23/04/24.
//

import Foundation
import SwiftUI

struct Spot {
    let title: String
    let image: Image?
    let text: String
    let category: String // oportunidades, servicios, artículos de segunda mano, cosas perdidas
}

extension Spot {
    
    static var spot1: Spot {
        Spot(
            title: "Busco a mi gato Mimmie",
            image: Image(.michi),
            text: "Perdí mi gato en la Av. Eugenio Garza Sada. Cualquier información me ayudaría 🙏. Contáctame al 0123456789",
            category: "Cosas perdidas"
        )
    }
    
    static var spot2: Spot {
        Spot(
            title: "Ofrezco clases de guitatarra",
            image: nil,
            text: "Doy clases de guitarra a principiantos. Tengo múltiples referencias. Más información al 9876543210",
            category: "Servicios"
        )
    }
    
    static var spot3: Spot {
        Spot(
            title: "Se solicita cajero en Oxxo",
            image: nil,
            text: "Trabajo de medio tiempo en Oxxo de Garza Sada. Sexo indifirente, mínimo 18 años con prepa terminada. Para más información contactar al 2222222222",
            category: "Servicios"
        )
    }
}
