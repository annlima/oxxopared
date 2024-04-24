//
//  SpotStore.swift
//  oxxopared
//
//  Created by Dicka J. Lezama on 24/04/24.
//

import Foundation
import SwiftUI

class SpotStore: ObservableObject {
    @Published var spots: [Spot] = [Spot.spot1, Spot.spot2, Spot.spot3, Spot.spot4]

    func addSpot(title: String, image: Image?, text: String, category: String) {
        let newSpot = Spot(title: title, image: image, text: text, category: category)
        spots.append(newSpot)
    }
}

