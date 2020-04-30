//
//  User.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/28/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var avatar_url: String?
    var url: String?
    var login: String?
    var repos_url: String?
}
