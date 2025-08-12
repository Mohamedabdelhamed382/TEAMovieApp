//
//  View .swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 12/08/2025.
//

import UIKit

extension UIView {
    
    func addTapGesture(numberOfTapsRequired: Int = 1, _ action: @escaping () -> Void) {
        endEditing(true)
        isUserInteractionEnabled = true
        
        let tap = MyTapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let p = tap.location(in: self)
        tap.action = action
        tap.numberOfTapsRequired = numberOfTapsRequired
        addGestureRecognizer(tap)
        
        endEditing(true)
    }
    
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var action: (() -> Void)?
    }
    
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: { self.alpha = 1.0 }, completion: nil)
        sender.action!()
    }
}

