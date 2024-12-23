import SwiftUI

struct DisneyFlashingIconView: View {
    @State private var isFlashing = false
    var size: CGFloat = 100 // Tamanho padrão

    var body: some View {
        ZStack {
            // Ícone centralizado
            if let image = UIImage(named: "iconDisney") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size) // Usa o tamanho ajustado
                    .shadow(color: isFlashing ? .white : .clear, radius: 10)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing)
                    .onAppear {
                        isFlashing = true
                    }
            } else {
                Text("Logo não encontrada")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .background(Color.clear) // Fundo transparente para reutilização
    }
}

// Preview
struct DisneyFlashingIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Simulação de tela onde a progress será chamada
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            DisneyFlashingIconView()
        }
    }
}
