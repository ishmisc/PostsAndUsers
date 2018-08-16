//
//  AutoLayoutConstraintsUtils.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit


extension NSLayoutConstraint {
    static func createEqualWithHeightToSuper(forView view : UIView) -> [NSLayoutConstraint]? {
        guard let superView = view.superview else { return nil }

        let width = NSLayoutConstraint(item: view,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: superView,
                                       attribute: .width,
                                       multiplier: 1,
                                       constant: 0)

        let height = NSLayoutConstraint(item: view,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: superView,
                                        attribute: .height,
                                        multiplier: 1,
                                        constant: 0)

        let centerX = NSLayoutConstraint(item: view,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: superView,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)

        let centerY = NSLayoutConstraint(item: view,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: superView,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)

        return [width, height, centerX, centerY]
    }
}
