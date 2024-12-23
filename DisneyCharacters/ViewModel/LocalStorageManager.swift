import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()

    private let userDefaults = UserDefaults.standard

    private init() {}

    func saveCharacters(forTab tab: String, characters: [DisneyCharacter]) {
        do {
            let data = try JSONEncoder().encode(characters)
            userDefaults.set(data, forKey: tab)
        } catch {
            print("Erro ao salvar personagens para a aba \(tab): \(error)")
        }
    }

    func loadCharacters(forTab tab: String) -> [DisneyCharacter]? {
        guard let data = userDefaults.data(forKey: tab) else { return nil }
        do {
            let characters = try JSONDecoder().decode([DisneyCharacter].self, from: data)
            return characters
        } catch {
            print("Erro ao carregar personagens para a aba \(tab): \(error)")
            return nil
        }
    }

    func clearCharacters(forTab tab: String) {
        userDefaults.removeObject(forKey: tab)
    }
    
    func clearAllCharacters() {
        ["Films", "Tv Shows", "Video Games", "Short Films"].forEach { tab in
            clearCharacters(forTab: tab)
        }
    }
}
