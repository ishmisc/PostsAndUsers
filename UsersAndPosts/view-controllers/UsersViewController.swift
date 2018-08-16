//
//  UsersViewController.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {

    var detailViewController: PostsViewController? = nil
    var users : [User] = []


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PostsViewController
        }

        self.fetchUsers()
    }


    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let user = users[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! PostsViewController
                controller.currentUser = user
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    // MARK: - Users fetching

    func fetchUsers() {
        let session = URLSession.init(configuration: .default)

        let usersURL = URL.init(string: "https://jsonplaceholder.typicode.com/users")!
        let task = session.dataTask(with: usersURL) { [weak self] (data, urlResponse, error) in

            if error == nil && data != nil {

                typealias UsersArray = [User]

                if let usersArray = try? JSONDecoder().decode(UsersArray.self, from: data!) {
                    DispatchQueue.main.async {
                        self?.users = usersArray
                        self?.tableView.reloadData()
                    }

                } else {
                    print("Couldn't parse data: " + String.init(data: data!, encoding: .utf8)! )
                }

            } else {
                if let error = error {
                    print(error)
                } else {
                    print("Unkown error")
                }
            }
        }

        task.resume()
    }


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.setUser(user)
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
