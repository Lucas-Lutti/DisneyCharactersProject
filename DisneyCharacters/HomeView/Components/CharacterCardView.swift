import SwiftUI

struct CharacterCardView: View {
    var character: DisneyCharacter
    var selectedTab: String

    var body: some View {
        HStack {
            if let imageUrl = character.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 5)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 5)
                    } else if phase.error != nil {
                        // Exibição em caso de erro
                        Text("Imagem indisponível")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width / 5, height: 80)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } else {
                        // Mostra a animação do ícone enquanto carrega
                        DisneyFlashingIconView(size: 40) // Ajuste o tamanho aqui
                                                   .frame(width: UIScreen.main.bounds.width / 5)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)

                Group {
                    if selectedTab == "Films", let film = character.films?.first {
                        Text("Filme: \(film)")
                    } else if selectedTab == "Short Films", let shortFilm = character.shortFilms?.first {
                        Text("Curta: \(shortFilm)")
                    } else if selectedTab == "Tv Shows", let tvShow = character.tvShows?.first {
                        Text("Série: \(tvShow)")
                    } else if selectedTab == "Video Games", let videoGame = character.videoGames?.first {
                        Text("Jogo: \(videoGame)")
                    } else {
                        Text("Mistério não revelado…")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 20))
                    .padding(.horizontal)
                Spacer()
            }
        }
        .frame(height: 120)
        .background(
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.horizontal, 0)
    }
}
