import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCharacters: [DisneyCharacter] = [] // Todos os personagens carregados
    @Published var displayedCharacters: [DisneyCharacter] = [] // Personagens filtrados para exibição
    @Published var selectedTab: String = "Films"
    @Published var searchText: String = "" // Texto da pesquisa
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true

    private var currentPage = 1
    private let pageSize = 10
    private let api = DisneyAPI()
    private var cancellables = Set<AnyCancellable>()

    private let localStorageManager = LocalStorageManager.shared

    init() {
        // Atualiza os personagens exibidos quando a aba muda ou o texto de busca muda
        Publishers.CombineLatest($selectedTab, $searchText)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] (_, searchText: String) in
                if searchText.isEmpty {
                    self?.applyFilters()
                } else {
                    self?.searchCharacters(by: searchText)
                }
            }
            .store(in: &cancellables)
    }

    /// Reseta o estado e carrega personagens até atingir 10 da categoria atual
    func resetAndLoadCharacters() {
        if searchText.isEmpty {
            // Primeiro tenta carregar do armazenamento local
            if let savedCharacters = localStorageManager.loadCharacters(forTab: selectedTab) {
                allCharacters = savedCharacters
                applyFilters()
            } else {
                // Se não houver dados locais, carrega da API
                allCharacters.removeAll()
                displayedCharacters.removeAll()
                currentPage = 1
                hasMorePages = true
                loadCharactersUntilMinimum()
            }
        }
    }

    /// Carrega mais personagens para incrementar os existentes
    func loadCharacters() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        api.getAllCharactersPaginated(page: currentPage, pageSize: pageSize) { [weak self] (result: Result<DisneyResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.handleNewCharacters(response.data)
                    self?.hasMorePages = response.info.nextPage != nil
                case .failure(let error):
                    print("Erro ao carregar personagens: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Carrega personagens até que pelo menos 10 da categoria atual sejam exibidos
    private func loadCharactersUntilMinimum() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        api.getAllCharactersPaginated(page: currentPage, pageSize: pageSize) { [weak self] (result: Result<DisneyResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.handleNewCharacters(response.data)

                    // Continue carregando se não houver pelo menos 10 personagens para exibição
                    if self?.displayedCharacters.count ?? 0 < 10, self?.hasMorePages == true {
                        self?.currentPage += 1
                        self?.loadCharactersUntilMinimum()
                    }
                case .failure(let error):
                    print("Erro ao carregar personagens: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Incrementa a lista com novos personagens
    private func handleNewCharacters(_ newCharacters: [DisneyCharacter]) {
        allCharacters.append(contentsOf: newCharacters)
        currentPage += 1
        applyFilters()

        // Salva personagens localmente
        localStorageManager.saveCharacters(forTab: selectedTab, characters: allCharacters)
    }

    /// Carrega personagens pelo nome
    func searchCharacters(by name: String) {
        // Limpa os dados da tabela antes de fazer a busca
        allCharacters.removeAll()
        displayedCharacters.removeAll()

        isLoading = true
        api.searchCharacter(by: name) { [weak self] (result: Result<DisneyResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.allCharacters = response.data
                    self?.applyFilters()
                case .failure(let error):
                    print("Erro ao buscar personagens: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Aplica filtros com base na aba selecionada
    private func applyFilters() {
        displayedCharacters = allCharacters.filter { character in
            switch selectedTab {
            case "Films": return character.films?.isEmpty == false
            case "Tv Shows": return character.tvShows?.isEmpty == false
            case "Video Games": return character.videoGames?.isEmpty == false
            case "Short Films": return character.shortFilms?.isEmpty == false
            default: return true
            }
        }
    }

    /// Limpa dados locais de todas as abas
    func clearLocalData() {
        localStorageManager.clearAllCharacters()
    }
}
