import Foundation

final class BookGeneralData {
    private init() {}
    
    static let manager = BookGeneralData()
    
    func getGeneralData(cathegory: String, completionHandler: @escaping(Result<[BookGeneralInfo], AppError>) -> ()) {
        let categoryNameForatted = cathegory.replacingOccurrences(of: " ", with: "-")
        
        let stringURL = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(Keys.nytKey)&list=\(categoryNameForatted)"
        
        guard let url = URL(string: stringURL) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let bookGeneralData = try JSONDecoder().decode(NYTBestSellersModel.self, from: data)
                    completionHandler(.success(bookGeneralData.results))
                } catch {
                    
                }
            }
        }
       
    }
    
}
