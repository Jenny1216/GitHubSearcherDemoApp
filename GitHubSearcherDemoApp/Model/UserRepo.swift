//
//  UserRepo.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/29/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import Foundation

struct UserRepo: Codable {
    var id: Int?
    var name: String?
    var html_url: String?
    var stargazers_count: Int?
    var forks_count: Int?
}
