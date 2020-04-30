//
//  UserProfileViC.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/28/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    var user: User?
    var userProfile: UserProfile?
    var userRepoArray: [UserRepo]?
    var filteredUserRepoArray: [UserRepo] = []
    var searchBarIsEditing = false
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joindateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.userProfileNibName, bundle: nil), forCellReuseIdentifier: K.userProfileCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfileDetails()
        getUserRepo()
    }
    
    func getUserProfileDetails() {
        GithubServices().fetchGithubUserProfile(url: user?.url) { [weak self] result in
            guard let strongSelf = self else { return }
            guard case .success(let data) = result else { return }
            strongSelf.userProfile = data
            DispatchQueue.main.async {
                self?.updateUserProfile()
            }
        }
    }
    
    func updateUserProfile() {
        usernameLabel.text = formatText(with: user?.login ?? "")
        emailLabel.text = userProfile?.email
        locationLabel.text = userProfile?.location
        joindateLabel.text = formateDate(with: userProfile?.created_at ?? "")
        
        if let followers = userProfile?.followers {
            followersLabel.text = "\(followers) Followers"
        }
        if let following = userProfile?.following {
            followingLabel.text = "Following \(following)"
        }
        biographyLabel.text = userProfile?.bio
        
        guard let avatarUrl = user?.avatar_url else { return }
        if let avatarUrl = URL(string: avatarUrl) {
            let data = NSData(contentsOf: avatarUrl)
            let avatarImage = UIImage(data: data! as Data)
            avatarImageView.image = avatarImage
        }
    }
    
    func getUserRepo() {
        GithubServices().fetchGithubUserRepo(url: user?.repos_url) { [weak self] result in
            guard let strongSelf = self else { return }
            guard  case .success(let data) = result else { return }
            strongSelf.userRepoArray = data
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func formatText(with text: String) -> String? {
        return String(text.prefix(1).capitalized) + String(text.dropFirst())
    }
    
    func formateDate(with text: String) -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}

//MARK:- UITableViewMethods
extension UserProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBarIsEditing == true {
            return filteredUserRepoArray.count
        } else {
            guard let userRepoArrayCount = userRepoArray?.count else {
                return 0
            }
            return userRepoArrayCount
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userProfileCellIdentifier, for: indexPath) as! UserProfileCell
        
        let user: UserRepo
        if searchBarIsEditing == true {
            user = filteredUserRepoArray[indexPath.row]
        } else {
            user = userRepoArray?[indexPath.row] as! UserRepo
        }
        cell.repoNameLabel.text = self.formatText(with: user.name!)
        if let forkCount = user.forks_count {
            cell.totalForksLabel.text = String("Forks \(forkCount)")
        }
        if let totalStars = user.stargazers_count {
            cell.totalStarsLabel.text = String("Stars \(totalStars)")
        }
        return cell
    }
}

//MARK:- UISearchBarDelegate
extension UserProfileVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let searchString = searchBar.text! + text
        searchBarIsEditing =  true
        filteredUserRepoArray = userRepoArray?.filter({ repo in
            return (repo.name?.lowercased().contains(searchString.lowercased()))!
        }) as! [UserRepo]
        tableView.reloadData()
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsEditing = false
        searchBar.resignFirstResponder()
    }
}
