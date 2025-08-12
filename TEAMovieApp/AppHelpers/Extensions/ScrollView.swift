//
//  ScrollView.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//

import UIKit

extension UIScrollView {
    func addRefresh(action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(nil, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
        
        // Assuming "helperLocalizable" is a method or property that fetches the localized string
        self.refreshControl?.attributedTitle = NSAttributedString(string: "", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
    }
}
