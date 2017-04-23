//
//  Message.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 23.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

class Message {
    var eventType: String?
    var messageId: String?
    var text: String?
    
    init(eventType: String, messageId: String, text:String) {
        self.eventType = eventType
        self.messageId = messageId
        self.text = text
    }
}
