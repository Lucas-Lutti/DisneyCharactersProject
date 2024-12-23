import Foundation

class DisneyAPI {
    private let baseURL = "https://api.disneyapi.dev"
    
    /// Função para buscar personagens com paginação usando REST
    func getAllCharactersPaginated(page: Int, pageSize: Int, completion: @escaping (Result<DisneyResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/character?page=\(page)&pageSize=\(pageSize)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    /// Função para buscar detalhes de um personagem específico
    func getCharacter(by id: Int, completion: @escaping (Result<CharacterDetails, Error>) -> Void) {
        let urlString = "\(baseURL)/character/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    /// Função genérica para realizar chamadas HTTP (REST)
    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado recebido"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchCharacter(by name: String, completion: @escaping (Result<DisneyResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/character?name=\(name)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        performRequest(url: url, completion: completion)
    }

}

