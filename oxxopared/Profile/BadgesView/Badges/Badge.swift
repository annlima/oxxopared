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
            gradientStart: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            gradientEnd: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),            symbolColor: .white,
            width: width
        )
        
    case 10:
        return Badge(
            gradientStart: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            gradientEnd: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            symbolColor: .black,
            width: width
        )
        
    case 20:
        return Badge(
            gradientStart: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            gradientEnd: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            symbolColor: .teal,
            width: width
        )
        
    case 30:
        return Badge(
            gradientStart: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            gradientEnd: Color(red: 240.0 / 255.0, green: 180 / 255.0, blue: 0 / 255.0),
            symbolColor: .red,
            width: width
        )
        
    case 1:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color(red: 255/255.0, green: 108/255.0, blue: 3/255.0),
            symbolColor: .white,
            width: width
        )
    
    case 11:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color(red: 255/255.0, green: 108/255.0, blue: 3/255.0),
            symbolColor: .black,
            width: width
        )
        
    case 21:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color(red: 255/255.0, green: 108/255.0, blue: 3/255.0),
            symbolColor: Color(red: 3/255.0, green: 170/255.0, blue: 255/255.0),
            width: width
        )
        
    case 31:
        return Badge(
            gradientStart: Color(red: 255.0 / 255.0, green: 170 / 255.0, blue: 66 / 255.0),
            gradientEnd: Color(red: 255/255.0, green: 108/255.0, blue: 3/255.0),
            symbolColor: Color(red: 209/255.0, green: 10/255.0, blue: 3/255.0),
            width: width
        )
        
    case 2:
        return Badge(
            gradientStart: Color.mint,
            gradientEnd: Color.teal,
            symbolColor: .white,
            width: width
        )
        
    case 12:
        return Badge(
            gradientStart: Color.mint,
            gradientEnd: Color.teal,
            symbolColor: .black,
            width: width
        )
            
    case 22:
        return Badge(
            gradientStart: Color.mint,
            gradientEnd: Color.teal,
            symbolColor: Color(red: 0 / 255.0, green: 36 / 255.0, blue: 153 / 255.0),
            width: width
        )
            
    case 32:
        return Badge(
            gradientStart: Color.mint,
            gradientEnd: Color.teal,
            symbolColor: Color(red: 16.0 / 255.0, green: 143 / 255.0, blue: 11 / 255.0),
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
        return "Colaborador - Representante"
    
    
    case 1:
        return "Vigilante - Oyente"
        
    case 11:
        return "Vigilante - Participante"
    
    case 21:
        return "Vigilante - Contribuyente"
    
    case 31:
        return "Vigilante - Representante"
    
    
        
    case 2:
        return "Ecológico - Oyente"
        
    case 12:
        return "Ecológico - Participante"
    
    case 22:
        return "Ecológico - Contribuyente"
    
    case 32:
        return "Ecológico - Representante"
    
        
    default:
        return ""
    }
}

func getAboutBadge(type: Int) -> String{
    
    switch type {
    case 0:
        return "Contribuyente: eres un miembro activo de tu comunidad"
        
    case 10:
        return "Contribuyente: haz destacado con tu participación en la comunidad"
    
    case 20:
        return "Contribuyente: "
    
    case 30:
        return "Contribuyente: "
        
    case 2:
        return "Ecológico"
        
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
