import Foundation

struct NYTBestSellersModel: Codable {
    
    let results: [BookGeneralInfo]
    
}

struct BookGeneralInfo: Codable {
    
    let cathegory: String //URL
    let rank: Int
    let bookDetails: [BookDetails]
    
    private enum CodingKeys: String, CodingKey {
      
        case cathegory = "list_name"
        case rank
        case bookDetails = "book_details"
    }
}

struct BookDetails: Codable {
   
    let title: String
    let description: String
    let author: String
    let primaryIsbn13: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case author
        case primaryIsbn13 = "primary_isbn13"
    }
    
}


    
  

