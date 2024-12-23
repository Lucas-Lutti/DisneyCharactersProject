import Foundation

// MARK: - DisneyCharacter Model

struct DisneyCharacter: Codable {
    let _id: Int
    let name: String
    let imageUrl: String?
    let films: [String]?
    let shortFilms: [String]?
    let tvShows: [String]?
    let videoGames: [String]?
    let parkAttractions: [String]?
    let allies: [String]?
    let enemies: [String]?
    let url: String?
}

// MARK: - CharacterDetails Model

/// Represents a detailed Disney character with additional information.
struct CharacterDetails: Codable {
    let id: Int
    let name: String
    let imageUrl: String?
    let films: [String]?
    let shortFilms: [String]?
    let tvShows: [String]?
    let videoGames: [String]?
    let parkAttractions: [String]?
    let allies: [String]?
    let enemies: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case imageUrl
        case films
        case shortFilms
        case tvShows
        case videoGames
        case parkAttractions
        case allies
        case enemies
    }
}
