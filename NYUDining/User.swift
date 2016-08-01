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
    
    var school: NYUSchools?
    var year: Int?
    var major: String?
    var description: String?
    
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
        return firstName ?? "nil"
    }
    
    func getLastName() -> String {
        return lastName ?? "nil"
    }
    
    func getYear() -> Int {
        return year ?? 0
    }
    
    func getMajor() -> String {
        return major ?? "nil"
    }
    
    func getDescription() -> String {
        return description ?? "nil"
    }
    
}