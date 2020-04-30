//
//  Services.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/28/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import Foundation

struct GithubServices {
    func fetchGithubUsers(handler: @escaping(Result<[User]?, Error>) -> Void) {
        guard let url = URL(string: K.Url.url) else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data else {
                handler(.failure(error!))
                return
            }
            let jsonDecoder = JSONDecoder()
            let users = try? jsonDecoder.decode([User].self, from: data)
            handler(.success(users))
        }.resume()
    }
    
    func fetchGithubUserProfile(url: String?, handler: @escaping(Result<UserProfile?, Error>) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data else {
                handler(.failure(error!))
                return
            }
            let jsonDecoder = JSONDecoder()
            let userProfile = try? jsonDecoder.decode(UserProfile.self, from: data)
            handler(.success(userProfile))
        }.resume()
    }
    
    func fetchGithubUserRepo(url: String?, handler: @escaping(Result<[UserRepo]?, Error>) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data else {
                handler(.failure(error!))
                return
            }
            let jsonDecoder = JSONDecoder()
            let userRepo = try? jsonDecoder.decode([UserRepo].self, from: data)
            handler(.success(userRepo))
        }.resume()
    }
}
