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
    static func isSignedIn() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
}