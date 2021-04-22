//
//  MainListViewController.swift
//  Articles List
//
//  Created by Agustin Errecalde on 08/04/2021.
//

import UIKit
import Network

final class MainListViewController: UIViewController {
    
    private var networkCheck = NetworkCheck.sharedInstance()
    private var refreshControl = UIRefreshControl()
    private var articles = [ArticleModel]()
    private var articlesIdDeleted = [Int]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoader()
        checkIfNetworkActive()
        setupUI()
        setupTableViewDelegates()
        registerTableViewCell()
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkCheck.addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkCheck.removeObserver(observer: self)
    }
    
    private func setupLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
    }
    
    private func setupTableViewDelegates() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
    }
    
    private func registerTableViewCell() {
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        checkIfNetworkActive()
    }
    
    private func setupUI() {
        clearNavBar()
        title = articleListTitle
    }
    
    private func checkIfNetworkActive() {
       if networkCheck.currentStatus == .satisfied{
            DispatchQueue.main.async {
                self.getData()
            }
       } else {
            DispatchQueue.main.async {
                self.getSavedData()
            }
       }
        
        articlesTableView.reloadData()
    }
    
    private func showAlert(errorDescription: String) {
        let alert = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getData() {
        APIController().fetchArticles { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                self.articlesTableView.reloadData()
                self.loader.stopAnimating()
            case .failure(let error):
                self.showAlert(errorDescription: error.localizedDescription)
                self.loader.stopAnimating()
            }
        }

        refreshControl.endRefreshing()
    }
    
    private func getSavedData() {
        APIController().getSavedArticles { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                self.articlesTableView.reloadData()
                self.loader.stopAnimating()
            case .failure(let error):
                self.showAlert(errorDescription: error.localizedDescription)
                self.loader.stopAnimating()
            }
        }
        refreshControl.endRefreshing()
    }
    
    private func goToDetails(article: ArticleModel) {
        guard let url = article.storyUrl else {
            showAlert(errorDescription: removeEmptyUrlError)
            return
        }
        let detailsViewController = ArticleDetailsViewController(nibName: "ArticleDetailsViewController", bundle: nil)
        detailsViewController.uriString = url
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if networkCheck.currentStatus == .satisfied {
            generateSuccessImpactWhenTouch()
            goToDetails(article: articles[indexPath.row])
        } else {
            generateErrorImpactWhenTouch()
            showAlert(errorDescription: lostConnectionError)
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let articleSelected = articles[indexPath.row]
        if editingStyle == .delete && articleSelected.parentId != nil {
            generateSuccessImpactWhenTouch()
            articles.remove(at: indexPath.row)
            if let id = articleSelected.parentId {
                articlesIdDeleted.append(id)
                DispatchQueue.main.async {
                     APIController().setArticleIdDeleted(id: id)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            generateErrorImpactWhenTouch()
            self.showAlert(errorDescription: emptyArticleError)
        }
    }
    
}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        cell.setupCell(article: articles[indexPath.row])
        
        return cell
    }
    
}

extension MainListViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            getData()
        }else if status == .unsatisfied {
            getSavedData()
        }
    }
    
}
