

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}
