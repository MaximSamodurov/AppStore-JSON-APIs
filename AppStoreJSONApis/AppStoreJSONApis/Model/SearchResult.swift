import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Double?
    let artworkUrl100: String //app icon
    let screenshotUrls: [String]
    let formattedPrice: String
    let description: String
    let releaseNotes: String
}
