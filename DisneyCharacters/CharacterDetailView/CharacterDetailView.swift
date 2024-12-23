import SwiftUI

struct CharacterDetailView: View {
    var character: DisneyCharacter
    @Environment(\.presentationMode) var presentationMode // Gerencia o estado de navegação

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.indigo, Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                    }
                    Spacer()
                }
                .padding(.top, 16)

                ScrollView {
                    VStack(spacing: 20) {
                        if let imageUrl = character.imageUrl, let url = URL(string: imageUrl) {
                            ZStack {
                                // Progresso personalizado
                                DisneyFlashingIconView()
                                    .frame(width: 50, height: 50)
                                    .opacity(0.8) // Leve transparência
                                
                                // Carrega a imagem
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 300)
                                            .clipped()
                                            .cornerRadius(12)
                                            .shadow(radius: 10)
                                    } else if phase.error != nil {
                                        Text("Imagem indisponível")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 20)
                                    } else {
                                        EmptyView() // Ícone de progresso já gerenciado no ZStack
                                    }
                                }
                            }
                        }

                        Text(character.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 20) {
                            if let films = character.films, !films.isEmpty {
                                DetailSection(title: "Filmes", items: films)
                            }

                            if let shortFilms = character.shortFilms, !shortFilms.isEmpty {
                                DetailSection(title: "Curtas", items: shortFilms)
                            }

                            if let tvShows = character.tvShows, !tvShows.isEmpty {
                                DetailSection(title: "Séries", items: tvShows)
                            }

                            if let videoGames = character.videoGames, !videoGames.isEmpty {
                                DetailSection(title: "Jogos", items: videoGames)
                            }

                            if let parkAttractions = character.parkAttractions, !parkAttractions.isEmpty {
                                DetailSection(title: "Atrações nos Parques", items: parkAttractions)
                            }

                            if let allies = character.allies, !allies.isEmpty {
                                DetailSection(title: "Aliados", items: allies)
                            }

                            if let enemies = character.enemies, !enemies.isEmpty {
                                DetailSection(title: "Inimigos", items: enemies)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                .cornerRadius(12)
                        )
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true) // Esconde a barra de navegação padrão
    }
}

// MARK: - DetailSection
struct DetailSection: View {
    var title: String
    var items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCharacter = DisneyCharacter(
            _id: 308,
            name: "Queen Arianna",
            imageUrl: "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg",
            films: ["Tangled", "Tangled: Before Ever After"],
            shortFilms: ["Tangled Ever After", "Hare Peace"],
            tvShows: ["Once Upon a Time", "Tangled: The Series"],
            videoGames: ["Disney Princess Enchanting Storybooks", "Kingdom Hearts III"],
            parkAttractions: ["Celebrate the Magic", "Jingle Bell, Jingle BAM!"],
            allies: ["King Frederic"],
            enemies: ["Mother Gothel"],
            url: "https://api.disneyapi.dev/characters/308"
        )

        CharacterDetailView(character: mockCharacter)
    }
}
