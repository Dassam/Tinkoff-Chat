//
//  CompanionCell.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 28.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class CompanionCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

class FriendMessage: UITableViewCell {

    @IBOutlet weak var textLabelMessage: UITextView!
    
    
    
}
class UserMessage: UITableViewCell {
    
    @IBOutlet weak var textLabelMessage: UITextView!
    
}
