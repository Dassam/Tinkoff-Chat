//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 10.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
