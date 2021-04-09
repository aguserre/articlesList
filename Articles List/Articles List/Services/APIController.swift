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
    typealias GetFullListCompletionHandler = ([ArticleModel]? , AFError?) -> Void
    
    func fetchArticles(completion: @escaping GetFullListCompletionHandler) {
        let uri = "https://hn.algolia.com/api/v1/search_by_date?query=mobile"
        var articles = [ArticleModel]()
        var articlesDeleted = [Int]()
        getArticlesDeleted { (articles, error) in
            if let articles = articles {
                articlesDeleted = articles
            }
        }
        AF.request(uri).responseJSON { (response) in
            switch response.result {
            case.success(let data):
                if let JSON = data as? [String : Any],
                   let articlesArray = JSON["hits"] as? [[String : Any]] {
                    self.deleteAllRecords()
                    for art in articlesArray {
                        if let articleObject = ArticleModel(JSON: art) {
                            if !articlesDeleted.contains(articleObject.storyId ?? -1) {
                                articles.append(articleObject)
                                self.savedNewArticles(article: articleObject)
                            }
                        }
                    }
                }
                completion(articles, nil)
            case.failure(let error) :
                completion(nil, error)
            }
        }
    }
    
    func getArticlesDeleted(completion: @escaping ([Int]?, Error?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesDeleted")
        request.returnsObjectsAsFaults = true
        
        do {
            let result = try context.fetch(request)
            var articlesDeleted = [Int]()
            for data in result as! [NSManagedObject] {
                articlesDeleted.append(data.value(forKey: "id") as! Int)
            }
            completion(articlesDeleted, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func setArticleDeleted(id: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ArticlesDeleted", in: context) else {
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
    
    
    func getSavedArticles(completion: @escaping ([ArticleModel]?, Error?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleModelCD")
        request.returnsObjectsAsFaults = true
        
        do {
            let result = try context.fetch(request)
            var articles = [ArticleModel]()
            var articlesDeleted = [Int]()
            for data in result as! [NSManagedObject] {
                let dic: [String : Any] = [
                    "parent_id" : data.value(forKey: "parent_id") as Any,
                    "story_title" : data.value(forKey: "story_title") as Any,
                    "story_url" : data.value(forKey: "story_url") as Any,
                    "author" : data.value(forKey: "author") as Any,
                    "created_at_i" : data.value(forKey: "created_at_i") as Any]
                
                if let articleObject = ArticleModel(JSON: dic) {
                    getArticlesDeleted { (articles, error) in
                        if let articles = articles {
                            articlesDeleted = articles
                        }
                    }
                    if !articlesDeleted.contains(articleObject.storyId ?? -1) {
                        articles.append(articleObject)
                    }
                }
            }
            completion(articles, nil)
        } catch {
            completion(nil, error)
        }

    }
    
    func savedNewArticles(article: ArticleModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ArticleModelCD", in: context) else {
            return
        }
        
        let newArticle = NSManagedObject(entity: entity, insertInto: context)
        newArticle.setValue(article.storyId, forKey: "parent_id")
        newArticle.setValue(article.storyTitle, forKey: "story_title")
        newArticle.setValue(article.storyUrl, forKey: "story_url")
        newArticle.setValue(article.author, forKey: "author")
        newArticle.setValue(article.createdAt, forKey: "created_at_i")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleModelCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}
