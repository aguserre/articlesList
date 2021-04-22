//
//  ServiceManager.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

import UIKit
import Alamofire
import Network
import CoreData


class APIController: NSObject {
    
    func fetchArticles(completion: @escaping (Swift.Result<[ArticleModel], Error>) -> Void) {
        var articlesDeleted = [Int]()
        var articlesFiltered = [ArticleModel]()
        getArticlesIdDeleted { (articles) in
            if let articles = articles {
                articlesDeleted = articles
            }
        }
        
        AF.request(apiUri)
            .validate()
            .responseDecodable(of: Hits.self, completionHandler: { (response) in
                guard let data = response.data else { return }
                self.deleteAllRecords()
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(Hits.self, from: data)
                    for article in result.hits {
                        if !articlesDeleted.contains(article.parentId ?? -1) {
                            self.savedNewArticles(article: article)
                            articlesFiltered.append(article)
                        }
                    }
                    completion(.success(articlesFiltered))
                }  catch {
                    completion(.failure(error))
                }
            })
    }
    
    func getSavedArticles(completion: @escaping (Swift.Result<[ArticleModel], Error>) -> Void) {
        var articlesDeleted = [Int]()
        getArticlesIdDeleted { (articles) in
            if let articles = articles {
                articlesDeleted = articles
            }
        }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: articleModelSaved)
        request.returnsObjectsAsFaults = true
        
        do {
            let result = try context.fetch(request)
            var articles = [ArticleModel]()
            DispatchQueue.main.async {
                for data in result as! [NSManagedObject] {
                    let article: ArticleModel = ArticleModel(parentId: data.value(forKey: "parent_id") as? Int,
                                                               storyTitle: data.value(forKey: "story_title") as Any as? String,
                                                               storyUrl: data.value(forKey: "story_url") as Any as? String,
                                                               author: data.value(forKey: "author") as Any as? String,
                                                               createdAtI: data.value(forKey: "created_at_i") as Any as? Int)
                    if !articlesDeleted.contains(article.parentId ?? -1) {
                        articles.append(article)
                    }
                }
                completion(.success(articles))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getArticlesIdDeleted(completion: @escaping ([Int]?) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: articleModelDeleted)
        request.returnsObjectsAsFaults = true
        
        do {
            let result = try? context.fetch(request)
            var articlesDeleted = [Int]()
            for data in result as! [NSManagedObject] {
                articlesDeleted.append(data.value(forKey: "id") as! Int)
            }
            completion(articlesDeleted)
        }
    }
    
    func setArticleIdDeleted(id: Int) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: articleModelDeleted, in: context) else {
            return
        }
        let newArticle = NSManagedObject(entity: entity, insertInto: context)
        newArticle.setValue(id, forKey: "id")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savedNewArticles(article: ArticleModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: articleModelSaved, in: context) else {
            return
        }
        
        let newArticle = NSManagedObject(entity: entity, insertInto: context)
        newArticle.setValue(article.parentId, forKey: "parent_id")
        newArticle.setValue(article.storyTitle, forKey: "story_title")
        newArticle.setValue(article.storyUrl, forKey: "story_url")
        newArticle.setValue(article.author, forKey: "author")
        newArticle.setValue(article.createdAtI, forKey: "created_at_i")
        
        do {
            try? context.save()
        }
    }
    
    func deleteAllRecords() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: articleModelSaved)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            debugPrint(removeRecordsError)
        }
    }
    
}
