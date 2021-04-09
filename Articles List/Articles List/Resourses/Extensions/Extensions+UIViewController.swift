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
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
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
