//
//  FileDataStore.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 03.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class FileDataStore {
    
    static let userNameKey = "name"
    static let userInfoKey = "info"
    static let colorTextKey = "color"
    static let userImageAvatarKey = "avatar"
    
    static let fileName = "userData"
    
    let fileManager = FileManager.default
    
    enum DataError: Error {
        case FileNotExist(String)
        case UnarchiveError(String)
        case DataCastError(String)
    }
    
    func serialize(_ userData: UserData) -> Dictionary<String, Any>
    {
        let userImageAvatarData = NSKeyedArchiver.archivedData(withRootObject: userData.userImageAvatar)
        let colorTextData = NSKeyedArchiver.archivedData(withRootObject: userData.colorText)
        
        return [
            FileDataStore.userNameKey: userData.userName,
            FileDataStore.userInfoKey: userData.userInfo,
            FileDataStore.colorTextKey: colorTextData,
            FileDataStore.userImageAvatarKey: userImageAvatarData
        ]
    }
    
    func deserialize(_ data: Data) throws -> UserData?
    {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] else {
            throw DataError.UnarchiveError("Error appeared during unarchive dictionary")
        }
        guard let userName = dictionary[FileDataStore.userNameKey] as? String else {
            throw DataError.DataCastError("Cannot cast userName to String")
        }
        guard let userInfo = dictionary[FileDataStore.userInfoKey] as? String else {
            throw DataError.DataCastError("Cannot cast userInfo to String")
        }
        guard let colorText = NSKeyedUnarchiver.unarchiveObject(with: dictionary[FileDataStore.colorTextKey] as! Data) as? UIColor else {
            throw DataError.DataCastError("Cannot cast colorText to UIColor")
        }
        guard let userImageAvatar = NSKeyedUnarchiver.unarchiveObject(with: dictionary[FileDataStore.userImageAvatarKey] as! Data) as? UIImage else {
            throw DataError.DataCastError("Cannot cast userImageAvatar to UIImage")
        }
        
        return UserData(userName: userName,
                        userInfo: userInfo,
                        colorText: colorText,
                        userImageAvatar: userImageAvatar)
    }
    
    func saveUserData(_ userData: UserData) throws {
        let dictionary = serialize(userData)
        let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        try data.write(to: getFilePath())
    }
    
    func loadUserData() throws -> UserData? {
        let filePath = getFilePath()
        guard fileManager.fileExists(atPath: filePath.path) else {
            print("File "+filePath.path+" not exist");
            return UserData.createDefaultProfile()
        }
        let data = try Data(contentsOf: filePath)
        
        let userData = try deserialize(data)
        return userData
    }
    
    func getFilePath() -> URL {
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent(FileDataStore.fileName)
    }
    
}
