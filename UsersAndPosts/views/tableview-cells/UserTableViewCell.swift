//
//  UserTableViewCell.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!


    func setUser(_ user : User) {
        self.nameLabel.text = user.name
        self.usernameLabel.text = user.username
        self.emailLabel.text = user.email
        self.addressLabel.text = user.address.asSingleString()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.usernameLabel.text = nil
        self.emailLabel.text = nil
        self.addressLabel.text = nil
    }
}
