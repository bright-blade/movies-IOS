

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let genreIds: [Int]
    let title: String
    let overview: String
    let voteAverage: Double
    let releaseDate: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case id
        case title
        case overview
    }
}

