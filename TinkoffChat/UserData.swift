//
//  UserData.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on  02.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

extension UserData: Equatable {}

func ==(left: UserData, right: UserData) -> Bool {
    return left.userName == right.userName
        && left.userInfo == right.userInfo
        && left.colorText == right.colorText
        && left.userImageAvatar == right.userImageAvatar
}

struct UserData {
    let userName: String
    let userInfo: String
    let colorText: UIColor
    let userImageAvatar: UIImage

   
    func hasDefaultUserImageAvatar() -> Bool {
        return self.userImageAvatar == #imageLiteral(resourceName: "ProfilePicture")
    }
    
    static func createDefaultProfile() -> UserData {
        let defaultUserName = ""
        let defaultUserInfo = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        let defaultColor = UIColor.black
        let defaultImage = #imageLiteral(resourceName: "ProfilePicture")
        return UserData(
            userName: defaultUserName,
            userInfo: defaultUserInfo,
            colorText: defaultColor,
            userImageAvatar: defaultImage)
    }

    func createNewUserData(userName: String? = nil, userInfo: String? = nil, colorText: UIColor? = nil, userImageAvatar: UIImage? = nil) -> UserData {
    
        let newUserName = userName ?? self.userName
        let newUserInfo = userInfo ?? self.userInfo
        let newColorText = colorText ?? self.colorText
        let newUserImageAvatar = userImageAvatar ?? self.userImageAvatar
        
        return UserData(userName: newUserName, userInfo: newUserInfo, colorText: newColorText, userImageAvatar: newUserImageAvatar)
    }
}
