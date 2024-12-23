import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAlert = false // Para exibir um alerta ao tocar no botão de configurações

    var body: some View {
        NavigationView {
            ZStack {
                // Fundo com gradiente
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.indigo, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    // Barra superior com botão de configurações
                    TopBarView(title: "Disney Characters") {
                        showAlert = true // Exibe o alerta
                    }

                    // Filtros de categorias
                    CharacterFilterView(selectedTab: $viewModel.selectedTab, searchText: $viewModel.searchText)
                        .padding(.horizontal)
                        .onChange(of: viewModel.selectedTab) { _ in
                            viewModel.resetAndLoadCharacters()
                        }


                    // Lista de personagens
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.displayedCharacters, id: \._id) { character in
                                NavigationLink(
                                    destination: CharacterDetailView(character: character)
                                ) {
                                    CharacterCardView(character: character, selectedTab: viewModel.selectedTab)
                                }
                                .buttonStyle(PlainButtonStyle()) // Remove o destaque padrão do botão
                            }

                            // Indicador de carregamento
                            if viewModel.isLoading {
                                ProgressView("Carregando...")
                                    .padding()
                            } else if viewModel.hasMorePages {
                                // Carrega mais personagens quando o final da lista é alcançado
                                Color.clear
                                    .frame(height: 1)
                                    .onAppear {
                                        viewModel.loadCharacters()
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                if viewModel.allCharacters.isEmpty {
                    viewModel.resetAndLoadCharacters()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Limpar Dados Locais"),
                    message: Text("Deseja apagar todos os dados salvos localmente?"),
                    primaryButton: .destructive(Text("Limpar")) {
                        LocalStorageManager.shared.clearAllCharacters()
                        viewModel.resetAndLoadCharacters()
                    },
                    secondaryButton: .cancel(Text("Cancelar"))
                )
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
