//
//  MCQquestionShowerViewController.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 07/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//
import UIKit
var Score = 0

class MCQquestionShowerViewController: UIViewController {
    var counter = Int32()
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnoption1: UIButton!
    @IBOutlet weak var btnoption2: UIButton!
    @IBOutlet weak var lblquestiontext: UILabel!
    @IBOutlet weak var btnoption3: UIButton!
    @IBOutlet weak var btnoption4: UIButton!
    @IBOutlet weak var lblCurrentQuestionnoShower: UILabel!
    var mcqbeanobj: MCQBean?
    var levelno: Int32 = Int32()
    var questionstorearray:NSMutableArray?
    var answertempstore: String?
    var Score = 0
    var a = Int32()
    var attempts = Int32()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController!.navigationBar.topItem!.title = ""
        
        self.view.isUserInteractionEnabled = true
        QuestionGenarater()
        ButtonlabelCornerRadiousSetter()
        self.navigationItem.title = "Level:- \(levelno)"
        var counter: Int = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        counter = 1
        lblCurrentQuestionnoShower.text = " \(counter) "
        a = 0
        Score = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if UserDefaults.standard.value(forKey: "MCQScore") != nil
        {
            let highscore:Int = Int((DefaultValueHelper.GetPrefwithKey("MCQScore") as String))!
            print(highscore)
            if (Score > highscore)
            {
                DefaultValueHelper.setPrefWithValueAndKey(String(Score), key: "MCQScore")
            }
        }
        else
        {
            DefaultValueHelper.setPrefWithValueAndKey(String(Score), key: "MCQScore")
        }
     }
    
    func QuestionGenarater() -> () {

        if(Score < 0)
        {
            lblScore.text = "0"
        }
        lblScore.text = "\(Score)"
            questionstorearray = DBhelperobj.selectAllGroups()
        ButtonReseter()
        var b = NSMutableArray()
        print(counter)
        if(counter < 10)
        {
            counter = counter + 1
            lblCurrentQuestionnoShower.text = "\(counter)"
            print(a)
            mcqbeanobj = questionstorearray?.object(at: Int(a)) as? MCQBean
             lblquestiontext.text = " " + (mcqbeanobj?.Question)!
            answertempstore = mcqbeanobj?.Answer
            a = a + 1
            OPtionSetter()
        }
        else
        {
            lblScore.text = "0"
            let GotoVc_Signup:ScoreViewController = storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
            GotoVc_Signup.scoreforresult = Int32(Score)
            
            if let navigator = navigationController {
                navigator.pushViewController(GotoVc_Signup, animated: true)
            }
            
             // Send to results Screen
        }
    }
    func OPtionSetter() {
        var a: Int32 = randomNumber(MAX: 3, MIN: 0)
        switch a {
        case 0:
            btnoption1.setTitle(mcqbeanobj?.Answer, for: .normal)
            btnoption2.setTitle(mcqbeanobj?.option2,for: .normal)
            btnoption3.setTitle(mcqbeanobj?.option3,for: .normal)
            btnoption4.setTitle(mcqbeanobj?.option1,for: .normal)
        case 1:
            btnoption1.setTitle(mcqbeanobj?.option1,for: .normal)
            btnoption2.setTitle(mcqbeanobj?.Answer, for: .normal)
            btnoption3.setTitle(mcqbeanobj?.option3,for: .normal)
            btnoption4.setTitle(mcqbeanobj?.option2,for: .normal)
        case 2:
            btnoption1.setTitle(mcqbeanobj?.option1,for: .normal)
            btnoption2.setTitle(mcqbeanobj?.option2,for: .normal)
            btnoption3.setTitle(mcqbeanobj?.Answer, for: .normal)
            btnoption4.setTitle(mcqbeanobj?.option3,for: .normal)
        case 3:
            btnoption1.setTitle(mcqbeanobj?.option1,for: .normal)
            btnoption2.setTitle(mcqbeanobj?.option2,for: .normal)
            btnoption3.setTitle(mcqbeanobj?.option3,for: .normal)
            btnoption4.setTitle(mcqbeanobj?.Answer, for: .normal)
        default:
            print("Nothing to do!")
        }
    }
    func randomNumber(MAX: Int32,MIN: Int32) -> Int32
    {
        let random_number = Int(arc4random_uniform(UInt32(MAX)) + arc4random_uniform(UInt32(MIN)))
        print ("random = ", random_number);
        return Int32(random_number)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnoption4method(_ sender: AnyObject) {
         if btnoption4.titleLabel?.text == answertempstore {
            self.btnoption4.backgroundColor     = UIColor.green
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false
            ScoreIncrement()
            let delaytimer = DispatchTime.now() + 1

            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                 self.QuestionGenarater()
            }
        }
        else
        {
            self.btnoption4.backgroundColor = UIColor.red
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false

            Scoredecrement()
            let delaytimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
    }
    @IBAction func btnoption3method(_ sender: AnyObject) {
        
        let btn = sender as? ZFRippleButton
        btn?.ripplePercent = 50
        btn?.rippleColor = .white
        btn?.shadowRippleEnable = true

        
        if btnoption3.titleLabel?.text == answertempstore {
            self.btnoption3.backgroundColor     = UIColor.green
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false
            ScoreIncrement()
            let delaytimer = DispatchTime.now() + 1
             DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
        else
        {
            self.btnoption3.backgroundColor = UIColor.red
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false

            Scoredecrement()
            let delaytimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
    }
     @IBAction func btnoption2method(_ sender: AnyObject) {
        if btnoption2.titleLabel?.text == answertempstore {
            self.btnoption2.backgroundColor     = UIColor.green
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false
            ScoreIncrement()
            let delaytimer = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
        else
        {
            self.btnoption2.backgroundColor = UIColor.red
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false

            Scoredecrement()
            let delaytimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
     }
    @IBAction func btnoption1method(_ sender: AnyObject) {
        if btnoption1.titleLabel?.text == answertempstore {
            self.btnoption1.backgroundColor = UIColor.green
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false
            ScoreIncrement()
            let delaytimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
            self.QuestionAnimation(self.view)
            self.QuestionGenarater()
            }
        }
        else
        {
            self.btnoption1.backgroundColor = UIColor.red
            btnoption1.isUserInteractionEnabled = false
            btnoption2.isUserInteractionEnabled = false
            btnoption3.isUserInteractionEnabled = false
            btnoption4.isUserInteractionEnabled = false
            Scoredecrement()
            let delaytimer = DispatchTime.now() + 0.10
            DispatchQueue.main.asyncAfter(deadline: delaytimer){
                self.QuestionAnimation(self.view)
                self.QuestionGenarater()
            }
        }
    }
    func ButtonlabelCornerRadiousSetter() {
        
        btnoption1.layer.cornerRadius       = 10
        btnoption2.layer.cornerRadius       = 10
        btnoption3.layer.cornerRadius       = 10
        btnoption4.layer.cornerRadius       = 10
        lblquestiontext.layer.cornerRadius  = 10
    }
    func ButtonReseter()  {
        btnoption1.backgroundColor          = UIColor.white
        btnoption2.backgroundColor          = UIColor.white
        btnoption3.backgroundColor          = UIColor.white
        btnoption4.backgroundColor          = UIColor.white
        btnoption1.isUserInteractionEnabled = true
        btnoption2.isUserInteractionEnabled = true
        btnoption3.isUserInteractionEnabled = true
        btnoption4.isUserInteractionEnabled = true
    }
    
    func ScoreIncrement()  {
        Score = Score + 20
    }
    
    func Scoredecrement()  {
        
    }
    func QuestionAnimation(_ myview: UIView) {
        UIView.transition(with: myview, duration: 0.40, options: UIViewAnimationOptions.transitionFlipFromRight, animations: { () -> Void in
            
        }) { (completed) -> Void in
            
        }
    }

}
