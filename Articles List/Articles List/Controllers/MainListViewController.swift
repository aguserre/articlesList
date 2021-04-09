//
//  MainListViewController.swift
//  Articles List
//
//  Created by Agustin Errecalde on 08/04/2021.
//

import UIKit
import Network

final class MainListViewController: UIViewController {
    
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        clearNavBar()
        title = "Article list"
    }

}
