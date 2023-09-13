

import Foundation

struct MovieReview: Codable, Identifiable {
    var id: String
    var author: String
    var content: String
}
