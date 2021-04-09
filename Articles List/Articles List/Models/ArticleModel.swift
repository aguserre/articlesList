//
//  ArticleModel.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

import ObjectMapper

final class ArticleModel: Mappable {

    var storyId: Int?
    var storyTitle: String?
    var storyUrl: String?
    var author: String?
    var createdAt: Int?

    required init?(map: Map) {}

    func mapping(map: Map) {
        storyId <- map["parent_id"]
        storyTitle <- map["story_title"]
        storyUrl <- map["story_url"]
        author <- map["author"]
        createdAt <- map["created_at_i"]
    }

    func toDictionary() -> NSDictionary {
        return ["parent_id": storyId  ?? "",
                "story_title": storyTitle ?? [:],
                "story_url": storyUrl ?? "",
                "author": author as Any,
                "created_at_i" : createdAt as Any] as NSDictionary
    }
        
}
