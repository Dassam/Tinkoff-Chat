//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 02.05.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation

class ServiceAssembly {
    
    static func profileDataService() -> DataProtocol {
        let coreDataStack = CoreDataStack()
        return ProfileDataService(with: coreDataStack)
    }
}
