//
//  Badge.swift
//  echo
//
//  Created by Dicka J. Lezama on 24/02/24.
//

import SwiftUI


func getBadge(type: Int, width: CGFloat) -> Badge {

    switch type {
        
    case 0: 
        return Badge(
            gradientStart: Color(red: 105 / 255.0, green: 202 / 255.0, blue: 255 / 255.0),
            gradientEnd: Color.blue,
            symbolColor: .white,
            width: width
        )
        
    case 10:
        return Badge(
            gradientStart: Color(red: 105 / 255.0, green: 202 / 255.0, blue: 255 / 255.0),
            gradientEnd: Color.blue,
            symbolColor: Color(red: 255 / 255.0, green: 87 / 255.0, blue: 51 / 255.0),
            width: width
        )
        
    case 20:
        return Badge(
            gradientStart: Color(red: 105 / 255.0, green: 202 / 255.0, blue: 255 / 255.0),
            gradientEnd: Color.blue,
            symbolColor: Color(red: 212 / 255.0, green: 175 / 255.0, blue: 55 / 255.0),
            width: width
        )
        
    case 30:
        return Badge(
            gradientStart: Color(red: 105 / 255.0, green: 202 / 255.0, blue: 255 / 255.0),
            gradientEnd: Color.blue,
            symbolColor: .black,
            width: width
        )
        
    case 1:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color.orange,
            symbolColor: .white,
            width: width
        )
    
    case 11:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color.orange,
            symbolColor: Color(red: 255 / 255.0, green: 87 / 255.0, blue: 51 / 255.0),
            width: width
        )
        
    case 21:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color.orange,
            symbolColor: Color(red: 212 / 255.0, green: 175 / 255.0, blue: 55 / 255.0),
            width: width
        )
        
    case 31:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color.orange,
            symbolColor: .black,
            width: width
        )
        
    case 2:
        return Badge(
            gradientStart: Color.mint,
            gradientEnd: Color.teal,
            symbolColor: .black,
            width: width
        )
        
    case 3:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 217 / 255.0),
            gradientEnd: Color.pink,
            symbolColor: .white,
            width: width
        )
    
    case 41:
        return Badge(width: width)

    default: 
        return Badge()
        
    }
}

func getTypeBadge(type: Int) -> String{
    
    switch type {
    case 0:
        return "Colaborador - Oyente"
        
    case 10:
        return "Colaborador - Participante"
    
    case 20:
        return "Colaborador - Contribuyente"
    
    case 30:
        return "Colaborador - Representate"
    
    case 4:
        return "Ecológico - Oyente"
        
    default:
        return ""
    }
}

func getAboutBadge(type: Int) -> String{
    
    switch type {
    case 0:
        return "Contribuyente: eres un miembro activo de tu comunidad"
        
    case 10:
        return "El periodista: tu denuncia fue elegida"
    
    case 20:
        return "Has hecho 30 denuncias"
    
    case 30:
        return "Has hecho 20 denuncias"
    
    case 4:
        return "Has hecho 10 denuncias"
        
    default:
        return ""
    }
}

struct Badge: View {
    
    var gradientStart = Color(red: 162.0 / 255.0, green: 214.0 / 255.0, blue: 5.0 / 255.0)
    var gradientEnd = Color.green
    var symbolColor: Color = Color(red: 0 / 255, green: 114 / 255, blue: 118 / 255)
    var width: CGFloat = 500
    
    var badgeSymbols: some View {
        ForEach(0..<8) { index in
            RotatedBadgeSymbol(
                angle: .degrees(Double(index) / Double(8)) * 360.0,
                width: width, 
                symbolColor: symbolColor
            )
        }
        .opacity(0.5)
    }

    var body: some View {
        ZStack {
            BadgeBackground(gradientStart: gradientStart, gradientEnd: gradientEnd)

            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
        
    }
}

#Preview {
    Badge()
}
