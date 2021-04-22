//
//  ArticleModel.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

struct Hits {
    var hits: [ArticleModel]
}

extension Hits: Decodable {
    enum Keys: String, CodingKey {
        case hits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.hits = try container.decode([ArticleModel].self, forKey: .hits)
    }
}

struct ArticleModel {
    var parentId: Int?
    var storyTitle: String?
    var storyUrl: String?
    var author: String?
    var createdAtI: Int?
}

extension ArticleModel: Decodable {
    enum Keys: String, CodingKey {
        case parentId
        case storyTitle
        case storyUrl
        case author
        case createdAtI
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.parentId = try container.decode(Int?.self, forKey: .parentId)
        self.storyTitle = try container.decode(String?.self, forKey: .storyTitle)
        self.storyUrl = try container.decode(String?.self, forKey: .storyUrl)
        self.author = try container.decode(String?.self, forKey: .author)
        self.createdAtI = try container.decode(Int?.self, forKey: .createdAtI)
    }
}
