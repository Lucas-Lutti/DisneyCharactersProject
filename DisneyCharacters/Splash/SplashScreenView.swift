import SwiftUI

struct SplashScreenView: View {
    @State private var showProgress = false
    @State private var fadeOut = false
    @State private var progressOpacity = 0.0 // Estado para o fade in da progress
    var onStartTapped: () -> Void

    var body: some View {
        ZStack {
            // Fundo com gradiente
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.indigo, Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            if showProgress {
                // Exibição da Progress personalizada com fade in
                DisneyFlashingIconView()
                    .opacity(progressOpacity) // Controla o fade in
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1)) {
                            progressOpacity = 1.0
                        }
                    }
            } else {
                VStack(spacing: 20) {
                    // Nome do aplicativo
                    Text("Disney Characters")
                        .font(.custom("Waltograph", size: 50)) // Fonte personalizada
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(fadeOut ? 0 : 1) // Aplica fade out ao texto

                    // Descrição do aplicativo
                    Text("Explore o universo Disney com uma incrível coleção de personagens e suas histórias mágicas!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .opacity(fadeOut ? 0 : 1) // Aplica fade out à descrição

                    // Botão criativo para começar
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            fadeOut = true // Inicia o fade out
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showProgress = true // Mostra a progress
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                onStartTapped() // Navega para a Home
                            }
                        }
                    }) {
                        ZStack {
                            // Fundo rotativo do botão com TimelineView para animação contínua
                            TimelineView(.animation) { context in
                                let rotation = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 2) * 360
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.orange]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 10)
                                    .rotationEffect(.degrees(rotation))
                            }

                            // Ícone fixo
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove o efeito de animação ao clicar
                    .opacity(fadeOut ? 0 : 1) // Aplica fade out ao botão
                }
            }
        }
    }
}

// Preview da tela inicial
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView {
            print("Navigated to Home")
        }
    }
}
