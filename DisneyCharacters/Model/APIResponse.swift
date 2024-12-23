import Foundation

// MARK: - API Response Models

struct DisneyResponse: Codable {
    let info: PageInfo
    let data: [DisneyCharacter]
}

struct PageInfo: Codable {
    let totalPages: Int
    let count: Int
    let previousPage: String?
    let nextPage: String?
}

struct DisneyAPIResponse: Codable {
    let info: APIInfo
    let data: [DisneyCharacter]
}

struct APIInfo: Codable {
    let count: Int
}
