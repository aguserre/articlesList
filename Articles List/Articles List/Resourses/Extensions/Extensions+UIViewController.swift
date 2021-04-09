//
//  Extensions+UIViewController.swift
//  Articles List
//
//  Created by Agustin Errecalde on 08/04/2021.
//

import UIKit

extension UIViewController {

    func clearNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func generateSuccessImpactWhenTouch() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func generateErrorImpactWhenTouch() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

}
