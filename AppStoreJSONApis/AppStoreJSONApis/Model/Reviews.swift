
// this structure from https://itunes.apple.com/rss/customerreviews/page=1/id=1641486558/sortby=mostrecent/json?l=en&cc=us

import Foundation

struct Reviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let title: Label
    let content: Label
    let author: Author
    let rating: Label
    
    //create custom coding key for let = rating, swift doesn't know about im:rating object (check "im:rating" in link above)
    private enum CodingKeys: String, CodingKey {
        case author, title, content
        case rating = "im:rating"
    }
}

struct Author: Decodable {
    let name: Label
}

struct Label: Decodable {
    let label: String
}


