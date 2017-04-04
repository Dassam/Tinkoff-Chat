//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 03.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit


class GCDDataManager: NSObject, DataProtocol {
    
    var dataStore = FileDataStore()
    let queue = DispatchQueue(label: "dataManagerQueue")
        
    func saveUserData(_ userData: UserData, completion: @escaping (Error?) -> Void) {
        queue.async {
            do
            {
                try self.dataStore.saveUserData(userData)
                DispatchQueue.main.async { completion(nil) }
            }
            catch
            {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    
    func loadUserData(completion: @escaping (UserData?, Error?) -> Void) {
        queue.async {
            do
            {
               let profile = try self.dataStore.loadUserData()
                DispatchQueue.main.async { completion(profile, nil) }
            }
            catch
            {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
}
