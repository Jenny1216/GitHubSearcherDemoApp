//
//  UserProfileCell.swift
//  GitHubSearcherDemoApp
//
//  Created by Jinisha Savani on 4/28/20.
//  Copyright © 2020 Jinisha Savani. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var totalForksLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
