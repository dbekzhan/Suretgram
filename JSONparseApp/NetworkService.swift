//
//  NetworkService.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    static var sourcelURL: String?
    
    func processData(from stringURL: String?, completion: @escaping (_ fetchedJSON: JSON) -> Void) {
        
        guard let stringURL = stringURL else { return }
        
        Alamofire.request(stringURL).responseJSON { (response) in
            if let serializedData = response.result.value {
                let json = JSON(serializedData)
                completion(json)
            }
        }
    }
    
    static func instantiateUser(fromData fetchedJSON: JSON) -> User? {
        
        guard let userJSON = fetchedJSON["graphql"]["user"].dictionary else { return nil }
        
        guard let userName = userJSON["username"]?.string else { return nil }
        
        let fullName = userJSON["full_name"]?.string
        let citation = userJSON["biography"]?.string
        let profilePicURL = userJSON["profile_pic_url"]?.string
        
        guard let isPrivate = userJSON["is_private"]?.bool else { print("no status info"); return nil }
        guard let numberOfSubscribers = userJSON["edge_followed_by"]?["count"].int else { print("no info about followers"); return nil }
        guard let numberofSubscriptions = userJSON["edge_follow"]?["count"].int else { print("no info of subscriptions"); return nil }
        guard let numberOfPosts = userJSON["edge_owner_to_timeline_media"]?["count"].int else {print("no posts"); return nil }
        
        let user =  User(userName: userName, fullName: fullName, citation: citation, isPrivate: isPrivate, numberOfSubscribers: numberOfSubscribers, numberOfSubscriptions: numberofSubscriptions, numberOfPosts: numberOfPosts, profilePicURL: profilePicURL)
        
        return user
    }
    
    static func instantiatePosts(fromData fetchedJSON: JSON) -> [Post]? {
        
        guard let postsJSON = fetchedJSON["graphql"]["user"]["edge_owner_to_timeline_media"].dictionary else { print("no postsJSON"); return nil }
        
        var posts = [Post]()
        
        guard let edgesJSON = postsJSON["edges"]?.array else { print("no edges json data"); return nil }
        
        for edgeJSON in edgesJSON {
            
            let postJSON = edgeJSON["node"]
            
            let isNotVideo = !postJSON["is_video"].bool!
            
            if isNotVideo {
                guard let imageStringURL = postJSON["display_url"].string else { print("there is no image url"); return nil }
                guard let numberOfLikes = postJSON["edge_liked_by"]["count"].int else { print("no likes"); return nil }
                guard let textDescription = postJSON["edge_media_to_caption"]["edges"].array![0]["node"]["text"].string else { return nil }
                
                let post = Post()
                post.imageStringURL = imageStringURL
                post.numberOfLikes = numberOfLikes
                post.postTextDescription = textDescription
                
                posts.append(post)
            }
        }
        
        return posts
    }
}
