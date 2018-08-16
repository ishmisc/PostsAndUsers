//
//  WaitingView.swift
//  UsersAndPosts
//
//  Created Iurii Shevchuk oe on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class WaitingView: UIView {

    @IBOutlet var centralContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.centralContainerView.backgroundColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)

        self.centralContainerView.layer.cornerRadius = 5
        self.centralContainerView.clipsToBounds = true
    }

    func addToMainWindow() {

        guard self.superview == nil else { return }

        if let window = AppDelegate.current.window {

            self.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(self)

            if let constrs = NSLayoutConstraint.createEqualWithHeightToSuper(forView: self) {
                NSLayoutConstraint.activate(constrs)
            }
        }
    }
}


extension WaitingView {
    class func loadFromNib() -> WaitingView {
        let topLevelObjs = Bundle.main.loadNibNamed("WaitingView", owner: self, options: nil)
        if let view = topLevelObjs?.first as? WaitingView {
            return view
        } else {
            fatalError("Could not load WaitingView from its nib")
        }
    }
}
