//
//  DataProtocol.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 03.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

protocol DataProtocol
    {
        func saveUserData(_ userData: UserData, completion: @escaping (Error?) -> Void)
        func loadUserData(completion: @escaping (UserData?, Error?) -> Void)
    }
