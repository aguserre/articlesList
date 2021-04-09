//
//  ArticleDetailsViewController.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

import UIKit
import WebKit

final class ArticleDetailsViewController: UIViewController {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        load()
    }
    
    private func load() {
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

}

extension ArticleDetailsViewController: WKNavigationDelegate {
    
}
