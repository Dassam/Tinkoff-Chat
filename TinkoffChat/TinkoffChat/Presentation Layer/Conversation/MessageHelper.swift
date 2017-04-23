//
//  MessageHelper.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 23.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

class MessageHelper {
    
    private let EVENT_TYPE = "TextMessage"
    
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) +\(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func createMessage(text: String) -> Message {
        let messageId = generateMessageId()
        return Message(eventType: EVENT_TYPE, messageId: messageId, text: text)
    }
    
    func serializeMessage(message: Message) -> Data? {
        let dict = ["eventType": message.eventType,
                    "messageId": message.messageId,
                    "text": message.text]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return jsonData
        } catch {
            print("Error while serializing message")
            return nil
        }
    }
    
    func deserializeMessage(data: Data) -> Message? {
        do {
            let res = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let eventType = res["eventType"] as? String
            let messageId = res["messageId"] as? String
            let text = res["text"] as? String
            return Message(eventType: eventType!, messageId: messageId!, text: text!)
        } catch {
            print("Error while deserializing data")
            return nil
        }
    }
}
