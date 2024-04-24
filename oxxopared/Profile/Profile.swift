//
//  Profile.swift
//  echo
//
//  Created by Azuany Mila Cerón on 06/03/24.
//

import SwiftUI


struct Profile {
    let name: String
    let profilePhoto: Image
    let spinPremia: Int
    let spots: [Spot]?
}


extension Profile {
    
    static var fer: Profile {
        Profile(
            name: "Fernando Ahuatzin",
            profilePhoto: Image(.michi),
            spinPremia: 1111111,
            spots: [
                Spot.spot1
            ]
        )
    }
}
