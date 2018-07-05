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
    
    func processData(from stringURL: String?, completion: @escaping (_ fetchedJSON: JSON) -> Void) {
        
        guard let stringURL = stringURL else { return }
        
        Alamofire.request(stringURL).responseJSON { (response) in
            if let serializedData = response.result.value {
                let json = JSON(serializedData)
                completion(json)
            }
        }
    }
}
