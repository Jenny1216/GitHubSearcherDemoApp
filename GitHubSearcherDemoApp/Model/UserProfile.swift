//
//  UserProfile.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/29/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var id: Int?
    var avatar_url: String?
    var repos_url: String?
    var name: String?
    var created_at: String?
    var email: String?
    var location: String?
    var following: Int?
    var followers: Int?
    var bio: String?
}
