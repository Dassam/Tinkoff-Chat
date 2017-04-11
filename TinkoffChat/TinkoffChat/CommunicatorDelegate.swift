//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 11.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLooseUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String)
}
