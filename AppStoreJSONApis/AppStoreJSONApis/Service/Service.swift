
import Foundation

class Service {
    static let shared = Service()
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, resp, err in

            // if errors
            if let err = err {
                print("Error To Fetch The Data", err)
                completion([], nil)
                return
            }
            // if success
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                completion(searchResult.results, nil)

            } catch let jsonError {
                print("Error with Decoding JSON", jsonError)
                completion([], jsonError)
            }
        }
        .resume() // fires off the request
    }
}
