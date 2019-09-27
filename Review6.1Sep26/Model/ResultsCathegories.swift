import Foundation


struct BookModel: Codable {
    var results: [Results]
    
}

struct Results: Codable {
    var listName: String
    
   
    
    private enum CodingKeys: String, CodingKey {
        case listName = "list_name"
    }
}
