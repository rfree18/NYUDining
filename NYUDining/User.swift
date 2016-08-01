//
//  User.swift
//  NYUDining
//
//  Created by Ross Freeman on 7/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class User {
    
    var fbUserId: String?
    var firstName: String?
    var lastName: String?
    var photoUrl: String?
    
    var school: String?
    var year: Int?
    var major: String?
    var description: String?
    var token:String?
    
    private static var privateCurrentUser: User?
    
    static func currentUser() -> User {
        guard let user = privateCurrentUser else {
            privateCurrentUser = User()
            return privateCurrentUser!
        }
        return user
    }
    
    static func logOut() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        privateCurrentUser = nil
    }
    
    static func isSignedIn() -> Bool {
        
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    
    func getFirstName() -> String {
        return firstName ?? "first"
    }
    
    func getLastName() -> String {
        return lastName ?? "last"
    }
    
    func getYear() -> Int {
        return year ?? 0
    }
    
    func getMajor() -> String {
        return major ?? "no major"
    }
    
    func getDescription() -> String {
        return description ?? "descript"
    }
    
}