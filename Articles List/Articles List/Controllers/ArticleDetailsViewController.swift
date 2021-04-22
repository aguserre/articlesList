//
//  ArticleDetailsViewController.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

import UIKit
import WebKit


final class ArticleDetailsViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    var uriString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.hidesWhenStopped = true
        loader.startAnimating()
        clearNavBar()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupWebView() {
        addNavigationGestures()
        webView.navigationDelegate = self
        webView.isHidden = true
        load()
    }
    
    private func addNavigationGestures() {
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsBackForwardNavigationGestures = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .right
        self.webView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(forwardAction))
        swipeLeft.direction = .left
        self.webView.addGestureRecognizer(swipeLeft)
    }
    
    private func load() {
        guard let url = URL(string: uriString) else {
            showAlert(errorDescription: siteCantBeLoadError)
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func showAlert(errorDescription: String) {
        let alert = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: okTitle, style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func forwardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
        
    @objc private func backAction() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
}

extension ArticleDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        loader.stopAnimating()
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loader.startAnimating()
    }

}

