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
    
    func setupCell(article: ArticleModel) {
        titleLabel.text = article.storyTitle
        authorLabel.text = article.author
        dateLabel.text = secondsToHoursMinutesSeconds(seconds: article.createdAt ?? Int(Date().timeIntervalSince1970))
        
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let intervalToday = Date().timeIntervalSince1970
        let intervalDiff = Date(timeIntervalSince1970: intervalToday - TimeInterval(seconds)).timeIntervalSince1970

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]

        formatter.unitsStyle = .abbreviated

        guard let formattedString = formatter.string(from: intervalDiff) else {
            return ""
        }

        return " - \(formattedString)"
    }
}
