//
//  ViewController.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 03/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "DashBoard"
      //  self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bgimage.png")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "DashBoard"
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

