import Foundation

class APIMAnagerWithCathegories {
  
    private init() {}
    
    static let manager = APIMAnagerWithCathegories()
    
    func getCathegories(completionHandler: @escaping(Result<[Results], AppError>) -> ()) {
//        let categoryNameForatted = cathegory.replacingOccurrences(of: " ", with: "-")
        
        let stringURL = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=J6SEDwslpxoVDzVkWNEYYRI0kv9voPFc"
        guard let url = URL(string: stringURL) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get, completionHandler: { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let bookData = try JSONDecoder().decode(BookModel.self, from: data)
                    completionHandler(.success(bookData.results))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        })
        
    }
}
