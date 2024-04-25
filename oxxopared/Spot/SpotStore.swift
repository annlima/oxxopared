//
//  SpotStore.swift
//  oxxopared
//
//  Created by Dicka J. Lezama on 24/04/24.
//

import Foundation
import SwiftUI

var spots: [Spot] = [Spot.spot1, Spot.spot2, Spot.spot3, Spot.spot4]

class SpotStore: ObservableObject {
    //@Published var spots: [Spot] = [Spot.spot1, Spot.spot2, Spot.spot3, Spot.spot4]

    func addSpot(title: String, image: Image?, text: String, category: String) ->Bool{
        let newSpot = Spot(title: title, image: image, text: text, category: category)
        spots.append(newSpot)
        return (true)
        
    }
    
    func addSpot2(title: String, text: String, category: String) ->Bool{
        let newSpot = Spot(title: title, text: text, category: category)
        spots.append(newSpot)
        return (true)
        
    }

}

