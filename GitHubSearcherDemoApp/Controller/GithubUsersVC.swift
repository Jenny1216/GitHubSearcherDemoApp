//
//  ViewController.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/28/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import UIKit

class GithubUsersVC: UIViewController {
    
    var usersArray: [User]?
    var filteredUsersArray: [User] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.githubUserCellNibName, bundle: nil), forCellReuseIdentifier: K.githubUserCellIdentifier)
    }
    
    func getData() {
        GithubServices().fetchGithubUsers { [weak self] (result) in
            guard let strongSelf = self else { return }
            guard case .success(let data) = result else { return }
            strongSelf.usersArray = data
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                print(data)
            }
        }
    }
}

//MARK:- UITableViewMethods
extension GithubUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsersArray.count
        }
        guard let usersTotal = usersArray?.count else {
            return 0
        }
        return usersTotal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.githubUserCellIdentifier, for: indexPath) as! GithubUsersCell
        
        let user: User
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsersArray[indexPath.row]
        } else {
            user = usersArray?[indexPath.row] as! User
        }
        
        let name = String(user.login!.prefix(1).capitalized) + String(user.login!.dropFirst())
        cell.userNameLabel.text = name
        
        if let id = user.id {
            cell.totalRepoLabel.text = "Repo:\(id)"
        }
        
        if let avatarUrl = URL(string: user.avatar_url!) {
            let data = NSData(contentsOf: avatarUrl)
            let avatarImage = UIImage(data: data! as Data)
            cell.avatarImageView.image = avatarImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        userProfileVC.user = usersArray?[indexPath.row]
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
}

//MARK:- SearchBarMethods
extension GithubUsersVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterUsersArray(for: searchController.searchBar.text ?? "")
    }
    
    private func filterUsersArray(for searchString: String) {
        filteredUsersArray = usersArray?.filter { user in
            return (user.login?.lowercased().contains(searchString.lowercased()))!
            } as! [User]
        tableView.reloadData()
    }
}
