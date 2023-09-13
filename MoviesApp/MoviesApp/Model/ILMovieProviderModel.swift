
import Foundation

struct ILMovieProviderModel: Codable {
    var il: MovieProvidersModel?
    
    enum CodingKeys: String, CodingKey {
        case il = "IL"
    }
}
