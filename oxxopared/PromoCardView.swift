import SwiftUI

struct Promo: Identifiable {
    var id = UUID()
    var title: String
    var detail: String
    var imageName: String
    var isRevealed: Bool = false
}

struct PromoCardView: View {
    @Binding var promo: Promo

    var body: some View {
        VStack {
            if promo.isRevealed {
                Button(action: {
                    openLink(promo.detail)
                }) {
                    Image(promo.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .clipped()
                }
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("RedMain"), Color("RedMain")]), startPoint: .top, endPoint: .bottom))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .frame(width: 150, height: 200)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("RedMain").opacity(0.6), Color("RedMain")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(12)
        .shadow(radius: 10, x: 5, y: 5)
        .onTapGesture {
            withAnimation(.spring()) {
                promo.isRevealed.toggle()
            }
        }
    }


    private func openLink(_ url: String) {
        guard let link = URL(string: url), UIApplication.shared.canOpenURL(link) else { return }
        UIApplication.shared.open(link)
    }
}

struct PromosView: View {
    @State private var promos = [
        Promo(title: "Clorox", detail: "https://www.oxxo.com/promociones/hogar", imageName: "promo1"),
        Promo(title: "Detergente Azálea", detail: "https://www.oxxo.com/promociones/hogar", imageName: "promo2")
    ]

    var body: some View {
        VStack {
            AuthHeaderView(title1: "Tu publicación", title2: "nos dice que te podría interesar esto...")
    
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.vertical, -10)
            
            HStack(spacing: 20) {
                ForEach($promos) { $promo in
                    PromoCardView(promo: $promo)
                }
            }
            .padding(.horizontal)

            if promos.allSatisfy({ $0.isRevealed }) {
                Button(action: savePromos) {
                    Text("Continuar")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("RedMain"))
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)

    }
    func savePromos() {
        print("Promos saved!")
    }
        
}
    

struct PromosView_Previews: PreviewProvider {
    static var previews: some View {
        PromosView()
    }
}

