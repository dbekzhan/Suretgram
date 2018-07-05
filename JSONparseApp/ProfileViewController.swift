//
//  ProfileViewController.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    let cellIdentifier = "postCell"
    var singleUser: User?
    
    // url is set during segue from segue.source
    var sourceURL: String?
    var posts: [Post]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewPosts.reloadData()
            }
        }
    }
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelPosts: UILabel!
    @IBOutlet weak var labelSubscribers: UILabel!
    @IBOutlet weak var labelSubscriptions: UILabel!
    @IBOutlet weak var labelPrivacy: UILabel!
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelCitation: UILabel!
    
    @IBOutlet weak var collectionViewPosts: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewPosts.delegate = self
        collectionViewPosts.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.initializeObjectsFromServer(withURL: self.sourceURL) { (success, modelObjects) in
            
            if success {
                
                guard let modeledSingleUser = modelObjects!["user"] as? User else { print("no users"); return }
                print("\(modeledSingleUser.userName)")
                guard let modeledPosts = modelObjects!["posts"] as? [Post] else { print("no posts"); return }
                
                self.singleUser = modeledSingleUser
                self.posts = modeledPosts
                
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func initializeObjectsFromServer(withURL sourceURL: String?, completion: @escaping (_ success: Bool, _ results: [ String : Any? ]?) -> Void ) {
        
        
        
        NetworkService.shared.processData(from: sourceURL) { fetchedJSON in
            
            guard let userJSON = fetchedJSON["graphql"]["user"].dictionary else { print("no userJSON"); return }
            guard let postsJSON = userJSON["edge_owner_to_timeline_media"]?.dictionary else { print("no postsJSON"); return }
            
            let user = self.instantiateUser(fromData: userJSON)
            let posts = self.instantiatePosts(fromData: postsJSON)
            
            let results: [ String : Any? ] = [
                "user": user,
                "posts": posts
            ]
            
            completion(true, results)
        }
    }
    
    func instantiateUser(fromData userJSON: [String : JSON]) -> User? {
        
        guard let userName = userJSON["username"]?.string else { print("no user name"); return nil }
        
        let fullName = userJSON["full_name"]?.string
        let citation = userJSON["biography"]?.string
        
        guard let isPrivate = userJSON["is_private"]?.bool else { print("no status info"); return nil }
        guard let numberOfSubscribers = userJSON["edge_followed_by"]?["count"].int else { print("no info about followers"); return nil }
        guard let numberofSubscriptions = userJSON["edge_follow"]?["count"].int else { print("no info of subscriptions"); return nil }
        
        let user =  User(userName: userName, fullName: fullName, citation: citation, isPrivate: isPrivate, numberOfSubscribers: numberOfSubscribers, numberOfSubscriptions: numberofSubscriptions)
        
        return user
    }
    
    func instantiatePosts(fromData postsJSON: [String : JSON]) -> [Post]? {
        
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


// MARK: - Collection View Delegate and Data Source
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PostCollectionViewCell else { fatalError("Could not dequeue cell with identifier: \(cellIdentifier)") }
        
        cell.post = posts?[indexPath.row]
        
        return cell
    }
}
