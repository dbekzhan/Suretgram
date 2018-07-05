//
//  PostCollectionViewCell.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    // var imageUrl: URL?
    
    @IBOutlet weak var imageViewPost: UIImageView!
    
    var post: Post? {
        didSet {
            getImageFromPostImageURL()
        }
    }
    
    func getImageFromPostImageURL() {
        if let imageStringURL = post?.imageStringURL {
            guard let url = URL(string: imageStringURL) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                if err != nil {
                    print(err?.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.imageViewPost.image = UIImage(data: data!)
                }
            }).resume()
        }
    }
}
