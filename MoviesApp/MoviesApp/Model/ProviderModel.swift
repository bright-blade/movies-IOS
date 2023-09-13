

import Foundation

struct ProviderModel: Codable, Identifiable {
    var logo: String
    var name: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case logo = "logo_path"
        case name = "provider_name"
        case id = "provider_id"
    }
}
