//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 03.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class LoadOperation: Operation
{
    let dataStore: FileDataStore
    let completion: (UserData?, Error?) -> Void
    
    init(with dataStore: FileDataStore,
         completion: @escaping (UserData?,Error?) -> Void)
    {
        self.completion = completion
        self.dataStore = dataStore
    }
    
    override func main()
    {
        if isCancelled
        {
            return
        }
        
        do {
            let userData = try dataStore.loadUserData()
            DispatchQueue.main.async {
                self.completion(userData, nil)
            }
        } catch {
            DispatchQueue.main.async {
                self.completion(nil, error)
            }
        }
    }
    
}

class SaveOperation: Operation
{
    let userData: UserData
    let dataStore: FileDataStore
    let completion: (Error?) -> Void
    
    init(with userData: UserData,
         dataStore: FileDataStore,
         completion: @escaping (Error?) -> Void)
    {
        self.userData = userData
        self.dataStore = dataStore
        self.completion = completion
    }
    
    override func main()
    {
        if isCancelled
        {
            return
        }
        
        do {
            try dataStore.saveUserData(userData)
            DispatchQueue.main.async {
                self.completion(nil)
            }
        } catch {
            DispatchQueue.main.async {
                self.completion(error)
            }
        }
    }
    
}

class OperationDataManager: NSObject, DataProtocol
{
    
    let dataStore = FileDataStore()
    let queue = OperationQueue()
    
    func saveUserData(_ userData: UserData, completion: @escaping (Error?) -> Void) {
        let saveOperation = SaveOperation(
            with: userData,
            dataStore: dataStore,
            completion: completion)
        queue.addOperation(saveOperation)
    }
    
    func loadUserData(completion: @escaping (UserData?, Error?) -> Void) {
        let loadOperation = LoadOperation(
            with: dataStore,
            completion: completion)
        queue.addOperation(loadOperation)
    }
}


