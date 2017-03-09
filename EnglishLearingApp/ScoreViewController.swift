//
//  ScoreViewController.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 09/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit
import LetsPod

class ScoreViewController: UIViewController {
    var scoreforresult = Int32()

    @IBOutlet weak var lblresultScore: UILabel!
    @IBOutlet weak var lblcurrentscore: UILabel!
    @IBOutlet weak var bottomview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = ""

        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        bottomview.layer.mask = maskLayer
        
        lblresultScore.text = "\(DefaultValueHelper.GetPrefwithKey("MCQScore") as String)"
        lblcurrentscore.text = "\(scoreforresult)"
      
        
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
