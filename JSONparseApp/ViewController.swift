//
//  ViewController.swift
//  JSONparseApp
//
//  Created by Dimash Bekzhan on 7/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonProceed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        // 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            
            guard let profileName = textFieldName.text else { return }
            NetworkService.sourcelURL = "https://apinsta.herokuapp.com/u/" + profileName
        }
    }
}

