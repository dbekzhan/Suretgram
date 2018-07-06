//
//  User.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

class User: NSObject {
    var userName: String
    var fullName: String?
    var citation: String?
    var isPrivate: Bool
    var profilePicURL: String?
    
    var numberOfPosts: Int
    var numberOfSubscribers: Int
    var numberOfSubscriptions: Int
    
    init(userName: String, fullName: String?, citation: String?, isPrivate: Bool, numberOfSubscribers: Int, numberOfSubscriptions: Int, numberOfPosts: Int, profilePicURL: String?) {
        self.userName = userName
        self.fullName = fullName
        self.citation = citation
        self.isPrivate = isPrivate
        
        self.profilePicURL = profilePicURL
        
        self.numberOfPosts = numberOfPosts
        self.numberOfSubscribers = numberOfSubscribers
        self.numberOfSubscriptions = numberOfSubscriptions
    }
}
