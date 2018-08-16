//
//  DetailViewController.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var currentUser: User? {
        didSet {
            self.updatePosts()
        }
    }

    private var currentRequest : CurrentRequest?
    private var currentPosts : [Post] = []


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updatePosts()
    }


    // MARK: - Private

    private func updatePosts() {

        guard let user = self.currentUser else {
            self.currentRequest?.task.cancel()
            self.currentRequest = nil
            self.currentPosts.removeAll()
            self.tableView.reloadData()
            return
        }


        if  let currentReq = self.currentRequest,
            currentReq.userId == user.id
        {
            // Just continue request
        }
        else
        {
            self.currentRequest?.task.cancel()

            let newTask = self.getPostsForUser(user)

            self.currentRequest = CurrentRequest(task: newTask, userId: user.id)
            newTask.resume()
        }
    }


    private func getPostsForUser(_ user : User) -> URLSessionTask
    {
        let session = URLSession.init(configuration: .default)

        let postsURL = URL.init(string: "https://jsonplaceholder.typicode.com/posts?userId=" + String(describing: user.id))!

        let postsUserId = user.id
        let task = session.dataTask(with: postsURL) { [weak self] (data, response, error) in
            if error == nil && data != nil {

                typealias PostsArray = [Post]

                if let postsArray = try? JSONDecoder().decode(PostsArray.self, from: data!) {
                    print(postsArray)

                    DispatchQueue.main.async {
                        if  let userId = self?.currentUser?.id,
                            userId == postsUserId
                        {
                            self?.currentPosts = postsArray
                            self?.tableView.reloadData()
                        }
                    }

                } else {
                    print("Couldn't parse data: " + String.init(data: data!, encoding: .utf8)! )
                }

            } else {
                print(error)
            }
        }

        return task
    }


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentPosts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        let post = self.currentPosts[indexPath.row]
        cell.setPost(post)
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


// MARK: -
// MARK: -

extension DetailViewController {
    struct CurrentRequest {
        let task : URLSessionTask
        let userId : Int
    }
}
