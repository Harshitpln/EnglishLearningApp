//
//  MCQTableViewController.swift
//  
//
//  Created by Lokesh on 03/03/17.
//
//

import UIKit
var DBhelperobj:Dbhelper = Dbhelper()

class MCQLevelViewController: UITableViewController {
    var MCQArray:MCQBean = MCQBean()
    var temparray:NSMutableArray = NSMutableArray()
    var level:Int32 = Int32()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Spelling Quiz"
        self.navigationController!.navigationBar.topItem!.title = "Back"
      //  temparray = DBhelperobj.selectAllGroups()
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MCQtableCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MCQtableCellTableViewCell", for: indexPath) as! MCQtableCellTableViewCell
            cell.lblQuestion.text = "Level No. \(indexPath.row + 1)"
            return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//        } else if editingStyle == .insert {
//    }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let GotoVc_Signup:MCQquestionShowerViewController = storyboard?.instantiateViewController(withIdentifier: "MCQquestionShowerViewController") as! MCQquestionShowerViewController
        GotoVc_Signup.levelno = Int32(indexPath.row + 1)
        if let navigator = navigationController {
            navigator.pushViewController(GotoVc_Signup, animated: true)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
