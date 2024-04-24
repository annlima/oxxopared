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
    let badges: [Int]
}


extension Profile {
    
    static var fer: Profile {
        Profile(
            name: "Fernando Ahuatzin",
            profilePhoto: Image(.fer),
            spinPremia: 1111111,
            spots: [
                Spot.spot1
            ],
            badges: [0,10,20,30,1,11,21,31,2,12,22,32]
        )
    }
}
