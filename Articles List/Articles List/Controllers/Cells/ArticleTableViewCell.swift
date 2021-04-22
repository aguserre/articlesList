//
//  ArticleTableViewCell.swift
//  Articles List
//
//  Created by Agustin Errecalde on 09/04/2021.
//

import UIKit
import Foundation


final class ArticleTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func setupCell(article: ArticleModel2) {
        titleLabel.text = article.storyTitle
        authorLabel.text = article.author
        let interval = article.createdAtI ?? Int(Date().timeIntervalSince1970)
        dateLabel.text = interval.getIntervalFormattedString()
    }

}
