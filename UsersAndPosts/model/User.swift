//
//  User.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


class User : Codable {
    var id : Int
    var name : String
    var username : String
    var email : String
    var address : Address


    init(id : Int, name : String, username : String, email : String, address : Address) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
    }


    struct Address : Codable {
        var street : String
        var suite : String
        var city : String
        var zipcode : String


        func asSingleString() -> String {
            return self.street + " " + self.suite + " " + self.city + " " + self.zipcode
        }
    }
}
