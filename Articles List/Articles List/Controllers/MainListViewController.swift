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
    private var articles = ["", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    @IBOutlet private weak var articlesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableViewDelegates()
        registerTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfNetworkActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkCheck.removeObserver(observer: self)
    }
    
    private func setupTableViewDelegates() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
    }
    
    private func registerTableViewCell() {
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       
    }
    
    private func setupUI() {
        clearNavBar()
        title = "Article list"
    }
    
    private func checkIfNetworkActive() {
        if networkCheck.currentStatus == .satisfied{
            getData()
        }else{
            getSavedData()
        }
        networkCheck.addObserver(observer: self)
    }
    
    private func getData() {
        
    }
    
    private func getSavedData() {
        
    }
    
    private func goToDetails(article: String) {
        let yourViewController = ArticleDetailsViewController(nibName: "ArticleDetailsViewController", bundle: nil)
        navigationController?.pushViewController(yourViewController, animated: true)
    }

}

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetails(article: articles[indexPath.row])
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        return cell
    }
    
    
}

extension MainListViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            print(status)
        }else if status == .unsatisfied {
            print(status)
        }
    }
}
