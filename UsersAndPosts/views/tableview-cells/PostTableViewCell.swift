//
//  PostTableViewCell.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!

    
    func setPost(_ post : Post) {
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.bodyLabel.text = nil
    }
}
