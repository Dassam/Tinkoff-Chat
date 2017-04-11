//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 11.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation
import UIKit

protocol CommunicatorManagerDelegate: class {
    func updateConversationList()
    func handleCommunicateError(error: Error)
}

class CommunicatorManager: NSObject, CommunicatorDelegate {
    
    let communicator = MultipeerCommunicator()
    weak var delegate: CommunicatorManagerDelegate?
    var peersOnline = [ConversationCell]()
    
    override init() {
        super.init()
        communicator.delegate = self
    }
    
    func getPeersOnline() -> [ConversationCell] {
        return peersOnline
    }

    func findPeerByID(userID: String) -> Int {
        for (index, cell) in peersOnline.enumerated() {
            if cell.name == userID {
                return index
            }
        }
        return -1
    }
    
    func didFindUser(userID: String, userName: String?)
    {
        print("didFindUser \(userID)")
        let index = findPeerByID(userID: userID)
        if (index < 0) {
            let cell = ConversationCell(name: userID, message: "",  date: Date(), online: true, hasUnreadMesseges: true)
            peersOnline.append(cell)
        }
        delegate?.updateConversationList()
    }
    
    func didLooseUser(userID: String)
    {
        print("didLooseUser \(userID)")
        let index = findPeerByID(userID: userID)
        if (index >= 0) {
            peersOnline.remove(at: index)
        }
        delegate?.updateConversationList()
    }
    
    func failedToStartBrowsingForUsers(error: Error)
    {
        print("failedToStartBrowsingForUsers \(error)")
    }
    
    func failedToStartAdvertising(error: Error)
    {
        print("failedToStartAdvertising \(error)")
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String)
    {
        print("didReceiveMessage \(text) \(fromUser) \(toUser)" )
    }
}
