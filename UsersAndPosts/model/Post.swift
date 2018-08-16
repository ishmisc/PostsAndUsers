//
//  Post.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct Post : Codable {
    var id : Int
    var userId : Int
    var title : String
    var body : String
}
