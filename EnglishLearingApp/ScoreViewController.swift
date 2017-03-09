//
//  ScoreViewController.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 09/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var lblresultScore: UILabel!
    @IBOutlet weak var lblcurrentscore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblresultScore.text = "\(DefaultValueHelper.GetPrefwithKey("MCQScore") as String)"
        lblcurrentscore.text = "\(Score)"
      
        
        if (UserDefaults.standard.value(forKey: "MCQScore") != nil)
        {
            print(DefaultValueHelper.GetPrefwithKey("MCQScore") as String)
        }
        else
        {
            print("0")
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var btnTryagain: UIButton!

    @IBAction func btnTryagainEvent(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnmainmenuevent(_ sender: AnyObject) {
    _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
