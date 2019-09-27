import Foundation

final class APIManager {
    
    private init() {}
    
    static let manager = APIManager()
    
    func getBook(category: String ,completionHandler: @escaping (Result<[BookItems], AppError>) -> () ) {
        
        let categoryNameForatted = category.replacingOccurrences(of: " ", with: "-")
        
     let stringURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(categoryNameForatted)&key=AIzaSyBWa3Ucwj1_LbL4CKueoDAX-xIhNGP2dow"
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
                          let bookData = try JSONDecoder().decode(GoogleData.self, from: data)
                            completionHandler(.success(bookData.items ?? []))
                        } catch {
                            print(error)
                            completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                        }
                    }
                })
        
    }
    
    
}

//https://api.nytimes.com/svc/books/v3/lists.json?api-key=J6SEDwslpxoVDzVkWNEYYRI0kv9voPFc&list=humor

