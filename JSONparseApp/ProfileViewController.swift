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
    var singleUser: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateProfileUI()
            }
        }
    }
    
    var posts: [Post]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewPosts.reloadData()
            }
        }
    }
    
    var selectedPost: Post?
    
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
        
        self.fetchObjectsFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProfileUI() {
        
        setProfileImage()
        
        self.labelSubscribers.text = "\(self.singleUser!.numberOfSubscribers)"
        self.labelSubscriptions.text = "\(self.singleUser!.numberOfSubscriptions)"
        self.labelPosts.text = "\(self.singleUser!.numberOfPosts)"
        
        if let fullName = self.singleUser!.fullName {
            self.labelFullName.text = fullName
        }
        if let citation = self.singleUser!.citation {
            self.labelCitation.text = citation
        }
        
        if self.singleUser!.isPrivate {
            self.labelPrivacy.text = "Private account"
        } else {
            self.labelPrivacy.text = "Open account"
        }
        
        navigationItem.title = self.singleUser!.userName
    }
    
    func fetchObjectsFromServer() {
        
        let sourceURL = NetworkService.sourcelURL
        
        NetworkService.shared.processData(from: sourceURL) { fetchedJSON in
            
            self.singleUser = NetworkService.instantiateUser(fromData: fetchedJSON)
            self.posts = NetworkService.instantiatePosts(fromData: fetchedJSON)
        }
        
    }
    
    func setProfileImage() {
        
        guard let profilePicURL = singleUser?.profilePicURL else { return }
        guard let url = URL(string: profilePicURL) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
            if err != nil {
                print(err?.localizedDescription)
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageViewProfile.image = UIImage(data: data)
            }
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            guard let postVC = segue.destination as? PostViewController else { return }
            postVC.post = self.selectedPost
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? PostCollectionViewCell
        
        selectedPost = selectedCell?.post
        
        performSegue(withIdentifier: "postSegue", sender: self)
    }
}

