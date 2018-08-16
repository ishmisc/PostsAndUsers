//
//  PostsViewController.swift
//  UsersAndPosts
//
//  Created by Iurii Shevchuk on 2018-08-16.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    var currentUser: User? {
        didSet {
            self.updatePosts()
        }
    }

    private var currentRequest : CurrentRequest?
    private var currentPosts : [Post] = []


    // MARK: - Object lifecycle

    deinit {
        self.currentRequest?.task.cancel()
    }


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePosts()
        if self.currentRequest != nil {
            self.setUIToLoadingState()
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // At this point we know that there is no other case
        // where this VC is disappearing beside being closed by user.
        // This is why we can cancel post requests
        self.currentRequest?.task.cancel()
        self.currentRequest = nil
    }


    // MARK: - Private UI related

    private func reloadTableView() {
        guard self.isViewLoaded else { return }
        self.tableView.reloadData()
    }


    private func setUIToLoadingState() {
        guard self.isViewLoaded else { return }
        self.title = "Please wait"
    }


    private func setUIToPresentationState() {
        guard self.isViewLoaded else { return }
        self.title = "Posts"
    }


    // MARK: - Private

    private func updatePosts() {

        guard let user = self.currentUser else {
            self.currentRequest?.task.cancel()
            self.currentRequest = nil
            self.currentPosts.removeAll()
            self.reloadTableView()
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

            self.setUIToLoadingState()
            
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
            DispatchQueue.main.async {
                self?.setUIToPresentationState()
                self?.currentRequest = nil
            }
            if error == nil && data != nil {

                typealias PostsArray = [Post]

                if let postsArray = try? JSONDecoder().decode(PostsArray.self, from: data!) {
                    DispatchQueue.main.async {
                        if  let userId = self?.currentUser?.id,
                            userId == postsUserId
                        {
                            self?.currentPosts = postsArray
                            self?.reloadTableView()
                        }
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
        cell.selectionStyle = .none
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }


    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


// MARK: -
// MARK: -

extension PostsViewController {
    struct CurrentRequest {
        let task : URLSessionTask
        let userId : Int
    }
}
