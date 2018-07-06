//
//  PostViewController.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/6/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelLikes: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI() {
        setPostImage()
        setLabels()
    }
    func setPostImage() {
        
        guard let imageURL = post?.imageStringURL else { return }
        guard let url = URL(string: imageURL) else { return }
        
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
    
    func setLabels() {
        if let post = post {
            if let postDescription = post.postTextDescription {
                labelDescription.text = postDescription
            }
            if let numberOfLikes = post.numberOfLikes {
                labelLikes.text = "\(numberOfLikes)"
            }
        }
    }
}
